import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    _startListeningToLocationUpdates();
  }

  @override
  void dispose() {
    super.dispose();
    _positionStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapbox Navigation Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _getCurrentLocationAndStartNavigation(context);
          },
          child: Text('Start Navigation'),
        ),
      ),
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



  Future<void> _getCurrentLocationAndStartNavigation(BuildContext context) async {
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
      name: "Ariana soghra",
      latitude: 36.77304889449085,
      longitude: 10.214799422729477,
    );
    await MapBoxNavigation.instance?.startNavigation(wayPoints: [Myposition,destination],options: MapBoxOptions(voiceInstructionsEnabled: false));
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
