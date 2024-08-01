import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/HomeView/navBar.dart';
import 'package:supplychaintracking/Views/OrderView/ListOrders.dart';
import 'package:supplychaintracking/Views/OrderView/TrackingOrders.dart';
import 'package:supplychaintracking/Views/OrderView/editOrder.dart';
import 'package:supplychaintracking/Views/Widgets/LineEditdiv2.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/Widgets/line_edit.dart';

class DetailsOrder extends StatefulWidget {
  final dynamic order;
  DetailsOrder(this.order);

  @override
  _DetailsOrderState createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder>
    with SingleTickerProviderStateMixin {

  late StompClient _stompClient; // Declare as late

  MapLeaflet _mapLeaflet = MapLeaflet();
  MapController _mapController = MapController();

  TextEditingController dateOrdersController = TextEditingController(text: '');
  TextEditingController productOrdersController =
  TextEditingController(text: '');
  TextEditingController weightOrdersController =
  TextEditingController(text: '');
  TextEditingController unitProductController = TextEditingController(text: '');
  TextEditingController startingPointController =
  TextEditingController(text: '');
  TextEditingController arrivalPointController =
  TextEditingController(text: '');
  TextEditingController estimationController = TextEditingController(text: '');
  TextEditingController statusController = TextEditingController(text: '');

  List<Marker> _markers = [];
  List<String> messages = [];
  List<dynamic> ordersTracking = [];

  bool? _isNavigating;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  OrderViewModel orderViewModel = OrderViewModel();



  late Timer _timer;




  @override
  void initState() {
    super.initState();

    // Initialize controllers with order data
    dateOrdersController.text = widget.order['dateOrders'];
    productOrdersController.text = widget.order['productOrders'];
    weightOrdersController.text = widget.order['weightOrders'].toString();
    unitProductController.text = widget.order['unitProduct'];
    startingPointController.text = widget.order['startingPoint'];
    arrivalPointController.text = widget.order['arrivalPoint'];
    estimationController.text = widget.order['estimation'];
    statusController.text = widget.order['status'];

    // Add route coordinates
    _mapLeaflet.routeCoordinates
        .add(LatLng(widget.order['startingLat'], widget.order['startingLong']));
    _mapLeaflet.routeCoordinates
        .add(LatLng(widget.order['arrivalLat'], widget.order['arrivalLong']));



    // Define initial markers
    _markers.addAll([
      Marker(
          width: 80.0,
          height: 80.0,
          point:
          LatLng(widget.order['startingLat'], widget.order['startingLong']),
          child:
          Column(children: [
            Image.asset("assets/images/maps/Pick_destination.png"),
            Text("Start",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.5)),)
          ],)
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(widget.order['arrivalLat'], widget.order['arrivalLong']),
        child: Column(children: [
          Image.asset("assets/images/maps/Pick_arrival.png"),
          Text("Arrival",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.5)),)
        ],),
      ),
    ]);

    // Fetch route coordinates
    _getRouteCoordinates();



  }



  void _connectToWebSocket() {
    _stompClient =
        StompClient(
          config: StompConfig(
            url: BaseURL.baseURL_WS,
            onConnect: _onConnect,
            onStompError: (error) {
              print('STOMP Error occurred: $error');
            },
            onWebSocketError: (error) {
              print('WebSocket Error occurred: $error');
            },
          ),
        );

    _stompClient.activate();
  }


  void _onConnect(StompFrame frame) {
    print("connected");
    _stompClient.subscribe(
      destination: '/setPosition/${widget.order['ordersNumber']}', // Update with your subscription topic
      callback: (frame) {
        Map<String, dynamic> result = json.decode(frame.body!);  // Add null check with '!'
        //setState(() {
        messages.add(result['message']);
        //});
      },
    );
  }

  Future<void> _sendMessage(String message) async {
    // print(message);
    if (_stompClient.connected) {
      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );


      //  print("Real Position : latitude"+position.latitude.toString() +" longitude"+ position.longitude.toString());
      if (widget.order['ordersNumber'].toString().isNotEmpty) {
        _stompClient.send(
          destination: '/app/getPosition/${widget.order['ordersNumber']}', // Update with your destination
          body: json.encode({'idOrders':widget.order['ordersNumber'],
            'ordersNowLat' : position.latitude,
            'ordersNowLong' : position.longitude
          }),
        );
        // _controller.clear();
      }
      else{
        print("non value hello");

      }
    } else {
      print('WebSocket connection is not established.');
      // You can attempt to reconnect here or display an error message to the user.
    }
  }


  void _startRealTimeMessaging() {

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      String message = "Real-time message at ${DateTime.now()}";
      if(widget.order['status']=="IN_PROGRESS")
        _sendMessage(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    //_stompClient.deactivate();
    //_timer.cancel();
    //_positionStreamSubscription?.cancel();
  }

  Future<void> _getRouteCoordinates() async {
    String osrmUrl = 'https://router.project-osrm.org/route/v1/driving/';
    LatLng origin = _mapLeaflet.routeCoordinates[0];
    LatLng destination = _mapLeaflet.routeCoordinates[1];

    String url =
        '$osrmUrl${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=polyline';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String encodedGeometry = data['routes'][0]['geometry'];

      List<PointLatLng> decodedPoints =
      PolylinePoints().decodePolyline(encodedGeometry);

      List<LatLng> coordinates = decodedPoints.map((point) {
        return LatLng(point.latitude, point.longitude);
      }).toList();

      double distance = data['routes'][0]['distance'] / 1000;
      int duration = data['routes'][0]['duration'] ~/ 60;

      setState(() {
        _mapLeaflet.routeCoordinates = coordinates;
        _mapLeaflet.distance = distance;
        _mapLeaflet.duration = duration;
        _mapLeaflet.distanceString = distance >= 1
            ? " (${distance.toStringAsFixed(2)} km)"
            : " (${(distance * 1000).toStringAsFixed(2)} m)";
      });

      // Adjust the zoom level to fit all the route coordinates
      _adjustZoomToFit();
    } else {
      print('Failed to fetch route coordinates');
    }
  }

  void _adjustZoomToFit() {
    LatLngBounds bounds = LatLngBounds(
        _mapLeaflet.routeCoordinates[0], _mapLeaflet.routeCoordinates[1]);
    for (var point in _mapLeaflet.routeCoordinates) {
      bounds.extend(point);
    }

    _mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(padding: EdgeInsets.all(60.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.order['status'],
          style: TextStyle(color: ColorTheme.titleAppBarColor),
        ),
        backgroundColor: ColorTheme.homeTopColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: ColorTheme.titleAppBarColor,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ListOrders()),
            );
          },
        ),
        actions: [
          if(widget.order['status']!="IN_PROGRESS")
              IconButton(
                color: ColorTheme.titleAppBarColor,
                icon: Icon(Icons.delete, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Delete"),
                        content: Text("Are you sure you want to delete this order "+widget.order['productOrders']+" ?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              if(await orderViewModel.deleteOrder(widget.order['ordersNumber'])){


                                Navigator.of(context).pop();

                              print('hello');
                              }
                              else{
                                Navigator.of(context).pop();

                              }
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

        ],
      ),
      body:
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(),
          ),
          Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: height,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                              color: ColorTheme.bigTitleColor, fontSize: 35),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        if (widget.order['status'] == 'COMPLETED' && widget.order['dateFinOrders'] != null)
                          LineEditdiv2(
                            title: dateOrdersController.text.substring(0, 10) +
                                " " +
                                dateOrdersController.text.substring(11, 16),
                            icon: Icons.calendar_month,
                            readOnly: true,
                            title2: widget.order['dateFinOrders'].substring(0, 10) +
                                " " +
                                widget.order['dateFinOrders'].substring(11, 16),
                            icon2: Icons.calendar_month,
                            readOnly2: true,
                          ),
                        if (widget.order['status'] != 'COMPLETED' || widget.order['dateFinOrders'] == null)
                          LineEditdiv2(
                            title: dateOrdersController.text.substring(0, 10) +
                                " " +
                                dateOrdersController.text.substring(11, 16),
                            icon: Icons.calendar_month,
                            readOnly: true,
                            title2: "Haven't arrived yet",
                            icon2: Icons.calendar_month,
                            readOnly2: true,
                          ),
                        SizedBox(height: 15),
                        LineEditdiv2(
                          title: productOrdersController.text,
                          icon: Icons.production_quantity_limits_sharp,
                          readOnly: true,
                          title2: weightOrdersController.text +
                              " " +
                              widget.order['unitProduct'],
                          icon2: FontAwesomeIcons.weightHanging,
                          readOnly2: true,
                        ),
                        SizedBox(height: 15),
                        LineEditdiv2(
                          title: startingPointController.text,
                          icon: FontAwesomeIcons.arrowUp,
                          readOnly: true,
                          title2: arrivalPointController.text,
                          icon2: FontAwesomeIcons.arrowDown,
                          readOnly2: true,
                        ),
                        SizedBox(height: 15),
                        LineEdit(
                          title: estimationController.text +
                              widget.order['distance'],
                          icon: Icons.access_time_filled,
                          readOnly: true,
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 400, // Adjust the height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorTheme.principalTeal,
                                width: 1.5), // Green border
                            borderRadius: BorderRadius.circular(
                                30), // Border radius to match ClipRRect
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                30), // Reduce by border width to fit inside the border
                            child: FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                center:
                                LatLng(34.0812055063, 9.417373468231718),
                                zoom: 6.7,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  additionalOptions: {
                                    'userAgent': 'com.example.app',
                                  },
                                ),
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: _mapLeaflet.routeCoordinates,
                                      color: Colors.blue,
                                      strokeWidth: 3.0,
                                    ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: _markers,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.order['status'] == 'IN_PROGRESS'
          ?

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*Container(
            width: 150,
            child: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () async {
                await _showConfirmationDialog();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "COMPLETED",
                    style: TextStyle(
                      color: ColorTheme.backgroundNormalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.check, color: ColorTheme.backgroundNormalColor),
                ],
              ),
            ),

          ),*/
          Container(
            width: 150,
            child:           FloatingActionButton(
              backgroundColor: ColorTheme.bigTitleColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TrackingOrders(widget.order)),
                );


              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "TRACKING NOW",
                    style: TextStyle(
                      color: ColorTheme.backgroundNormalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.emergency_share_sharp,
                      color: ColorTheme.backgroundNormalColor),
                ],
              ),
            ),
          ),


        ],
      )
          : Container(
        width: 150,
        child: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () async {
            if( widget.order['status'] != 'COMPLETED' )
            {

              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditOrder(widget.order)),
              );

              print("EDIT");
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              if (widget.order['status'] == 'PENDING' || widget.order['status'] == 'CANCELED'|| widget.order['status'] == 'DELAYED')
                Text(
                  "EDIT",
                  style: TextStyle(
                    color: ColorTheme.backgroundNormalColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (widget.order['status'] == 'PENDING' || widget.order['status'] == 'CANCELED'|| widget.order['status'] == 'DELAYED')
                Icon(Icons.edit, color: ColorTheme.backgroundNormalColor),

              if (widget.order['status'] == 'COMPLETED' )
                Text(
                  "COMPLETED",
                  style: TextStyle(
                    color: ColorTheme.backgroundNormalColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (widget.order['status'] == 'COMPLETED')
                Icon(Icons.verified, color: ColorTheme.backgroundNormalColor),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateAndAwaitResult(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListOrders()),
    );

    // Handle result after the second screen is popped
    print('Result: $result');
  }

}
