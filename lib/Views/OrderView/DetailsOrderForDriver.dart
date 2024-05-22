import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/ViewModel/OrderViewModel.dart';
import 'package:supplychaintracking/Views/MapView/NavigationMap.dart';
import 'package:supplychaintracking/Views/Widgets/LineEditdiv2.dart';
import 'package:supplychaintracking/Views/Widgets/colorTheme.dart';
import 'package:supplychaintracking/Views/Widgets/line_edit.dart';

class DetailsOrderForDriver extends StatefulWidget {
  final dynamic order;
  DetailsOrderForDriver(this.order);

  @override
  _DetailsOrderForDriverState createState() => _DetailsOrderForDriverState();
}

class _DetailsOrderForDriverState extends State<DetailsOrderForDriver>
    with SingleTickerProviderStateMixin {
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

  bool? _arrived;
  bool? _routeBuilt;
  bool? _isNavigating;
  String? _instruction;
  Position? _currentPosition;
  double _distanceRemaining = 0.0;
  double _durationRemaining = 0.0;
  bool _isMultipleStop = false;
  dynamic _controller;
  StreamSubscription<Position>? _positionStreamSubscription;

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
        child: Image.asset("assets/images/maps/Pick_destination.png"),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(widget.order['arrivalLat'], widget.order['arrivalLong']),
        child: Image.asset("assets/images/maps/Pick_arrival.png"),
      ),
    ]);

    // Fetch route coordinates
    _getRouteCoordinates();

    _startListeningToLocationUpdates();
  }

  @override
  void dispose() {
    super.dispose();
    _positionStreamSubscription?.cancel();
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
          },
        ),
      ),
      body: Stack(
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
                        if (widget.order['status'] == 'COMPLETED')
                          LineEditdiv2(
                            title: dateOrdersController.text.substring(0, 10) +
                                " " +
                                dateOrdersController.text.substring(11, 16),
                            icon: Icons.calendar_month,
                            readOnly: true,
                            title2: dateOrdersController.text.substring(0, 10) +
                                " " +
                                dateOrdersController.text.substring(11, 16),
                            icon2: Icons.calendar_month,
                            readOnly2: true,
                          ),
                        if (widget.order['status'] != 'COMPLETED')
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
      floatingActionButton: Container(
        width: 150, // set your desired width
        child: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            _getCurrentLocationAndStartNavigation(context);

            // Start the animation to the starting position
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "START",
                style: TextStyle(
                    color: ColorTheme.backgroundNormalColor,
                    fontWeight: FontWeight.bold),
              ),
              Icon(Icons.play_arrow, color: ColorTheme.backgroundNormalColor),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _startListeningToLocationUpdates() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;

        if (_isNavigating ?? false && _currentPosition != null) {
          MapBoxNavigation.instance?.startFreeDrive(
            options: MapBoxOptions(
              initialLatitude: _currentPosition!.latitude,
              initialLongitude: _currentPosition!.longitude,
            ),
          );
        }
      });
    });
  }

  Future<void> _getCurrentLocationAndStartNavigation(
      BuildContext context) async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });

    if (_currentPosition != null) {
      startNavigation(context, _currentPosition!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Current position is not available.'),
        ),
      );
    }
  }

  void startNavigation(BuildContext context, Position position) async {
    final Myposition = WayPoint(
      name: "Myposition",
      latitude: position.latitude,
      longitude: position.longitude,
    );
    final destination = WayPoint(
      name: arrivalPointController.text,
      latitude: widget.order['arrivalLat'],
      longitude: widget.order['arrivalLong'],
    );
    await MapBoxNavigation.instance?.startNavigation(
        wayPoints: [Myposition, destination],
        options: MapBoxOptions(
          voiceInstructionsEnabled: false,
          mapStyleUrlNight: "mapbox://styles/mapbox/navigation-night-v1",
        ));
/*
    await MapBoxNavigation.instance?.startFreeDrive(
      options: MapBoxOptions(
        zoom: 15,
        tilt: 0,
        bearing: 0,
        initialLongitude: position.longitude,
        initialLatitude: position.latitude,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        mapStyleUrlDay: "mapbox://styles/mapbox/outdoors-v12",
        mapStyleUrlNight: "mapbox://styles/mapbox/navigation-night-v1",
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        units: VoiceUnits.imperial,
        simulateRoute: false,
        animateBuildRoute: true,
        longPressDestinationEnabled: false, // Set to false to make destination unmodifiable
        language: 'en',
      ),
    );*/
  }
}
