

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Network/BaseURL.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:http/http.dart' as http;

class TrackingOrders extends StatefulWidget {
  final dynamic order;
  TrackingOrders(this.order);
  @override
  TrackingOrdersState createState() => TrackingOrdersState();
}

class TrackingOrdersState extends State<TrackingOrders>{

  double Lat=0 , Long =0;
  late StompClient _stompClient; // Declare as late
  late Timer _timer;
  List<double> messages = [];
  MapLeaflet _mapLeaflet = MapLeaflet();
  List<Marker> _markers = [];
  MapController _mapController = MapController();



  @override
  void initState() {
    super.initState();
    _connectToWebSocket();

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
      Marker(
        width: 50.0,
        height: 50.0,
        point: LatLng(Lat, Long),
        child: Column(children: [
          Image.asset("assets/images/maps/truckTracking.png"),
        ],),
      ),
    ]);

    // Fetch route coordinates
    _getRouteCoordinates();
    _startMarkerUpdateTimer();

  }
  void _startMarkerUpdateTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _updateMarker());
  }

  void _updateMarker() {
    // Simulate fetching the latest coordinates
    setState(() {
      _markers.removeLast();
      _markers.add(
      Marker(
      width: 50.0,
      height: 50.0,
      point: LatLng(Lat, Long),
      child: Column(children: [
      Image.asset("assets/images/maps/truckTracking.png"),
      ]),
      ),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

  return Scaffold(
      appBar:AppBar(
        title: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Text(
            "TRACKING",
            style: TextStyle(color: ColorTheme.titleAppBarColor),
          ),
        ),
        backgroundColor: ColorTheme.homeTopColor,
        centerTitle: true, // Center the title
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorTheme.titleAppBarColor,
            ),
            color: ColorTheme.titleAppBarColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    body: Container(
      child: Column(
        children: <Widget>[
          Container(
            height: height-109, // Adjust the height as needed
            decoration: BoxDecoration(
              border: Border.all(
                  color: ColorTheme.principalTeal,
                  width: 1.5), // Green border
              borderRadius: BorderRadius.circular(
                  0), // Border radius to match ClipRRect
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  0), // Reduce by border width to fit inside the border
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

  ) ;


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
        destination: '/setPosition/${widget.order['ordersNumber']}',
        // Update with your subscription topic
        callback: (frame) {
          Map<String, dynamic> result = json.decode(
              frame.body!); // Add null check with '!'
          setState(() {
           // messages.add(result['message']);
            Lat = result['ordersNowLat'];
            Long = result['ordersNowLong'];
            print(result);
            //});
          },
          );
        });
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
  void dispose() {
    super.dispose();
    _stompClient.deactivate();
  //  _timer.cancel();
  }










}