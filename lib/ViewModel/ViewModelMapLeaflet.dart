import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:supplychaintracking/Models/MapLeaflet.dart';

class ViewModelLeaflet extends ChangeNotifier {
  late MapLeaflet mapLeaflet;
  List<String> searchResults = [];

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late TickerProvider tickerProvider;
  late BuildContext context; // Add context field

  ViewModelLeaflet(this.context, this.tickerProvider) {
    mapLeaflet = MapLeaflet();
    searchFocusNode.addListener(_onSearchFocusChange);
  }

  void _onSearchFocusChange() {
    if (!searchFocusNode.hasFocus) {
      searchResults.clear();
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    mapLeaflet.currentPosition = LatLng(position.latitude, position.longitude);

    if (mapLeaflet.currentPosition != null) {
      _animateToPosition(mapLeaflet.currentPosition!, 15.0);
    }
    notifyListeners();
  }

  void _animateToPosition(LatLng position, double zoom) {
    final center = mapLeaflet.mapController.center;
    final startZoom = mapLeaflet.mapController.zoom;

    final interval = 0.01;
    final distance = Geolocator.distanceBetween(center.latitude, center.longitude, position.latitude, position.longitude);
    final duration = Duration(milliseconds: (interval * distance).toInt());

    final curve = Curves.easeInOut;

    final zoomTween = Tween<double>(begin: startZoom, end: zoom);
    final centerTween = LatLngTween(begin: center, end: position);

    AnimationController animationController = AnimationController(
      vsync: tickerProvider,
      duration: duration,
    );

    final animation = CurvedAnimation(parent: animationController, curve: curve);

    animation.addListener(() {
      final zoomValue = zoomTween.evaluate(animation);
      final centerValue = centerTween.evaluate(animation);
      mapLeaflet.mapController.move(centerValue, zoomValue);
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  List<Marker> buildMarkers() {
    List<Marker> markers = [];

    if (mapLeaflet.currentPosition != null) {
      markers.add(
        Marker(
          point: mapLeaflet.currentPosition!,
          width: 40,
          height: 40,
          child: Image.asset("assets/images/maps/myposition.png"),
        ),
      );
    }

    for (var i = 0; i < mapLeaflet.markerPositions.length; i++) {
      markers.add(
        Marker(
          point: mapLeaflet.markerPositions[i],
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              mapLeaflet.markerPositions.removeAt(i);
              mapLeaflet.routeCoordinates.clear();
              mapLeaflet.distance = 0.0;
              mapLeaflet.duration = 0;
              mapLeaflet.durationString = "";
              mapLeaflet.distanceString = "";
              notifyListeners();
            },
            child: i == 0
                ? Image.asset("assets/images/maps/Pick_destination.png")
                : Image.asset("assets/images/maps/Pick_arrival.png"),
          ),
        ),
      );
    }

    if (mapLeaflet.markerPositions.isNotEmpty &&
        mapLeaflet.routeCoordinates.isNotEmpty &&
        mapLeaflet.distance > 0 &&
        mapLeaflet.duration >= 0) {
      int hours = mapLeaflet.duration ~/ 60;
      int remainingMinutes = mapLeaflet.duration % 60;

      mapLeaflet.durationString = "";
      if (hours > 0) {
        mapLeaflet.durationString += '$hours ';
        mapLeaflet.durationString += 'h ';
      }

      if (remainingMinutes > 0) {
        mapLeaflet.durationString += '$remainingMinutes ';
        mapLeaflet.durationString += 'min';
      }
      if (mapLeaflet.duration == 0) {
        mapLeaflet.durationString += '1 min';
      }
    }

    return markers;
  }

  void handleTapOnMap(TapPosition tapPosition, LatLng tappedPosition) {
    if (mapLeaflet.markerPositions.length < 2) {
      mapLeaflet.markerPositions.add(tappedPosition);

      if (mapLeaflet.markerPositions.length == 2) {
        _getRouteCoordinates();
      }
    } else {
      mapLeaflet.markerPositions.clear();
      mapLeaflet.routeCoordinates.clear();
      mapLeaflet.distance = 0.0;
      mapLeaflet.duration = 0;
      mapLeaflet.durationString = "";
      mapLeaflet.distanceString = "";
    }
    notifyListeners();
  }

  void _getRouteCoordinates() async {
    String osrmUrl = 'https://router.project-osrm.org/route/v1/driving/';

    LatLng origin = mapLeaflet.markerPositions[0];
    LatLng destination = mapLeaflet.markerPositions[1];

    String url =
        '$osrmUrl${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String encodedGeometry = data['routes'][0]['geometry'];

      List<PointLatLng> decodedPoints =
      PolylinePoints().decodePolyline(encodedGeometry);

      List<LatLng> coordinates = decodedPoints.map((point) {
        double lat = point.latitude;
        double lng = point.longitude;
        return LatLng(lat, lng);
      }).toList();

      double distance = data['routes'][0]['distance'] / 1000;
      int duration = data['routes'][0]['duration'] ~/ 60;

      mapLeaflet.routeCoordinates = coordinates;
      mapLeaflet.duration = duration;

      if (distance >= 1) {
        mapLeaflet.distance = distance;
        mapLeaflet.distanceString = " (" + distance.toStringAsFixed(2) + "km)";
      } else {
        mapLeaflet.distance = distance * 1000;
        mapLeaflet.distanceString =
            " (" + mapLeaflet.distance.toStringAsFixed(2) + "m)";
      }

      _adjustZoomToFit();
    } else {
      print('Failed to fetch route coordinates');
    }
    notifyListeners();
  }

  void updateSearchResults(String value) async {
    searchResults.clear();

    if (value.isEmpty) {
      return;
    }

    try {
      String url =
          'http://nominatim.openstreetmap.org/search?q=$value&format=json&addressdetails=1&countrycodes=TN&accept-language=fr';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        Set<String> uniqueResults = {};
        for (var location in data) {
          uniqueResults.add(location['display_name']);
        }

        searchResults.addAll(uniqueResults.toList());
      } else {
        print('Error fetching search results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching search results: $e');
    }
    notifyListeners();
  }

  void handleSearchResultTap(String address) async {
    try {
      String url =
          'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data.isNotEmpty) {
          double latitude = double.parse(data[0]['lat']);
          double longitude = double.parse(data[0]['lon']);

          LatLng tappedPosition = LatLng(latitude, longitude);

          mapLeaflet.markerPositions.clear();
          mapLeaflet.routeCoordinates.clear();
          mapLeaflet.markerPositions.add(tappedPosition);

          if (mapLeaflet.choiceSelected ||
              mapLeaflet.markerPositions.length == 2) {
            _getRouteCoordinates();
          } else {
            _animateToPosition(tappedPosition, 15.0);
          }
        }
      } else {
        print('Error handling search result tap: ${response.statusCode}');
      }
    } catch (e) {
      print('Error handling search result tap: $e');
    }
    notifyListeners();
  }

  void searchAddress(String address) {
    if (searchResults.isNotEmpty) {
      handleSearchResultTap(searchResults.first);
    } else {
      handleSearchResultTap(address);
    }
  }

  void _adjustZoomToFit() {
    List<LatLng> allCoordinates = [
      ...mapLeaflet.markerPositions,
      ...mapLeaflet.routeCoordinates
    ];

    double minLat =
    allCoordinates.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat =
    allCoordinates.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double minLng =
    allCoordinates.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng =
    allCoordinates.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

    double fitWidth = maxLng - minLng;
    double fitHeight = maxLat - minLat;

    double padding = 50;

    double fitZoom = (log(360.0 / 256.0 * (MediaQuery.of(context!).size.width - 2 * padding) / fitWidth) / log(2)).compareTo(log(180.0 / 256.0 * (MediaQuery.of(context!).size.height - 2 * padding) / fitHeight) / log(2)) <
        0
        ? log(360.0 / 256.0 * (MediaQuery.of(context!).size.width - 2 * padding) / fitWidth) / log(2)
        : log(180.0 / 256.0 * (MediaQuery.of(context!).size.height - 2 * padding) / fitHeight) / log(2);

    mapLeaflet.mapController.move(LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2), fitZoom);
  }
}
