import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Services/MapLeafletService.dart';

class MapLeafletWidget extends StatefulWidget {
  @override
  _MapLeafletWidgetState createState() => _MapLeafletWidgetState();
}

class _MapLeafletWidgetState extends State<MapLeafletWidget>
    with TickerProviderStateMixin {
  MapLeaflet _mapLeaflet = MapLeaflet();
  MapLeafletService _mapLeafletService = MapLeafletService();

  List<String> _searchResults = [];

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    setState(() {
      if (!_searchFocusNode.hasFocus) {
        _searchResults.clear();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _mapLeaflet.currentPosition =
          LatLng(position.latitude, position.longitude);

      if (_mapLeaflet.currentPosition != null) {
        _animateToPosition(_mapLeaflet.currentPosition!, 15.0);
      }
    });
  }

  void _animateToPosition(LatLng position, double zoom) {
    final center = _mapLeaflet.mapController.center;
    final startZoom = _mapLeaflet.mapController.zoom;

    final interval = 0.01;
    final distance = Geolocator.distanceBetween(center.latitude,
        center.longitude, position.latitude, position.longitude);
    final duration = Duration(milliseconds: (interval * distance).toInt());

    final curve = Curves.easeInOut;

    final zoomTween = Tween<double>(begin: startZoom, end: zoom);
    final centerTween = LatLngTween(begin: center, end: position);

    AnimationController animationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    final animation =
    CurvedAnimation(parent: animationController, curve: curve);

    animation.addListener(() {
      final zoomValue = zoomTween.evaluate(animation);
      final centerValue = centerTween.evaluate(animation);
      _mapLeaflet.mapController.move(centerValue, zoomValue);
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapLeaflet.mapController,
            options: MapOptions(
              center: LatLng(34.0812055063, 9.417373468231718),
              zoom: 6.7,
              onLongPress: _handleTapOnMap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                markers: _buildMarkers(),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white.withOpacity(0.0),
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
                onChanged: (value) =>
                    _updateSearchResults(value), // Update this line
                onSubmitted: (value) => _searchAddress(value),
              ),
            ),
          ),
          if (_searchFocusNode.hasFocus)
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _mapLeaflet.searchResults.map((result) {
                    return ListTile(
                      title: Text(result),
                      onTap: () {
                        _handleSearchResultTap(result);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Container(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${_mapLeaflet.durationString}",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_mapLeaflet.distanceString}",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    if (_mapLeaflet.currentPosition != null) {
      markers.add(
        Marker(
          point: _mapLeaflet.currentPosition!,
          width: 40,
          height: 40,
          child: Image.asset("assets/images/maps/myposition.png"),
        ),
      );
    }

    for (var i = 0; i < _mapLeaflet.markerPositions.length; i++) {
      markers.add(
        Marker(
          point: _mapLeaflet.markerPositions[i],
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _mapLeaflet.markerPositions.removeAt(i);
                _mapLeaflet.routeCoordinates.clear();
                _mapLeaflet.distance = 0.0; // Clear distance
                _mapLeaflet.duration = 0; // Clear duration
                _mapLeaflet.durationString = "";
                _mapLeaflet.distanceString = "";
              });
            },
            child: i == 0
                ? Image.asset("assets/images/maps/Pick_destination.png")
                : Image.asset("assets/images/maps/Pick_arrival.png"),
          ),
        ),
      );
    }

    if (_mapLeaflet.markerPositions.isNotEmpty &&
        _mapLeaflet.routeCoordinates.isNotEmpty &&
        _mapLeaflet.distance > 0 &&
        _mapLeaflet.duration >= 0) {
      int hours = _mapLeaflet.duration ~/ 60;
      int remainingMinutes = _mapLeaflet.duration % 60;

      _mapLeaflet.durationString = "";
      if (hours > 0) {
        _mapLeaflet.durationString += '$hours ';
        _mapLeaflet.durationString += 'h ';
      }

      if (remainingMinutes > 0) {
        _mapLeaflet.durationString += '$remainingMinutes ';
        _mapLeaflet.durationString += 'min';
      }
      if (_mapLeaflet.duration == 0) {
        _mapLeaflet.durationString += '1 min';
      }
    }

    return markers;
  }

  void _handleTapOnMap(TapPosition tapPosition, LatLng tappedPosition) {
    if (_mapLeaflet.markerPositions.length < 2) {
      setState(() {
        _mapLeaflet.markerPositions.add(tappedPosition);
      });

      if (_mapLeaflet.markerPositions.length == 2) {
        _getRouteCoordinates();
      }
    } else {
      setState(() {
        _mapLeaflet.markerPositions.clear();
        _mapLeaflet.routeCoordinates.clear();
        _mapLeaflet.distance = 0.0; // Clear distance
        _mapLeaflet.duration = 0; // Clear duration
        _mapLeaflet.durationString = "";
        _mapLeaflet.distanceString = "";
      });
    }
  }

  void _getRouteCoordinates() async {
    String osrmUrl = 'https://router.project-osrm.org/route/v1/driving/';

    LatLng origin = _mapLeaflet.markerPositions[0];
    LatLng destination = _mapLeaflet.markerPositions[1];

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

      setState(() {
        _mapLeaflet.routeCoordinates = coordinates;
        _mapLeaflet.duration = duration;
      });

      if (distance >= 1) {
        setState(() {
          _mapLeaflet.distance = distance;
          _mapLeaflet.distanceString =
              " (" + distance.toStringAsFixed(2) + "km)";
        });
      } else {
        setState(() {
          _mapLeaflet.distance = distance * 1000;
          _mapLeaflet.distanceString =
              " (" + _mapLeaflet.distance.toStringAsFixed(2) + "m)";
        });
      }

      _adjustZoomToFit();
    } else {
      print('Failed to fetch route coordinates');
    }
  }

  void _updateSearchResults(String value) async {
    setState(() {
      _mapLeaflet.searchResults.clear();
      _mapLeaflet.choiceSelected = false; // Reset the flag
    });

    if (value.isEmpty) {
      return; // Exit function if search value is empty
    }

    try {
      // Construct the search query
      String url =
          'http://nominatim.openstreetmap.org/search?q=$value&format=json&addressdetails=1&countrycodes=TN&accept-language=fr';

      // Make the HTTP GET request
      var response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        List<dynamic> data = json.decode(response.body);

        Set<String> uniqueResults = {}; // Set to store unique addresses
        print(data);
        int i = 0;
        for (var location in data) {
          i++;
          // Extract relevant address components
          String amenity = location['address']['amenity'] ?? '';
          String name = location['address']['name'] ?? '';
          String state = location['address']['state'] ?? '';
          String county = location['address']['county'] ?? '';

          //s String fullAddress= amenity+" "+name+" "+state+" "+county +"" +location[''];
          uniqueResults.add(location['display_name']);
        }
        print(uniqueResults.length);

        setState(() {
          _mapLeaflet.searchResults.clear();
          for (String chaine in uniqueResults) {
            print(chaine);
            _mapLeaflet.searchResults.add(chaine);
          }
          print(_mapLeaflet.searchResults.length);
          // _mapLeaflet.searchResults.addAll(uniqueResults.toList());
        });
      } else {
        // Handle the error if the request was not successful
        print('Error fetching search results: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any other errors
      print('Error fetching search results: $e');
    }
  }

  void _handleSearchResultTap(String address) async {
    try {
      // Construct the search query
      String url =
          'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1';

      // Make the HTTP GET request
      var response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        var data = json.decode(response.body);

        if (data.isNotEmpty) {
          // Extract location coordinates
          double latitude = double.parse(data[0]['lat']);
          double longitude = double.parse(data[0]['lon']);

          LatLng tappedPosition = LatLng(latitude, longitude);

          setState(() {
            _mapLeaflet.markerPositions.clear();
            _mapLeaflet.routeCoordinates.clear();
            _mapLeaflet.markerPositions.add(tappedPosition);
          });

          if (_mapLeaflet.choiceSelected ||
              _mapLeaflet.markerPositions.length == 2) {
            _getRouteCoordinates();
          } else {
            _animateToPosition(tappedPosition, 15.0);
          }
        }
      } else {
        // Handle the error if the request was not successful
        print('Error handling search result tap: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any other errors
      print('Error handling search result tap: $e');
    }
  }

  void _searchAddress(String address) {
    if (_searchResults.isNotEmpty) {
      _handleSearchResultTap(_searchResults.first);
    } else {
      _handleSearchResultTap(address);
    }
  }

  void _adjustZoomToFit() {
    List<LatLng> allCoordinates = [
      ..._mapLeaflet.markerPositions,
      ..._mapLeaflet.routeCoordinates
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

    double fitZoom = (log(360.0 /
        256.0 *
        (MediaQuery.of(context).size.width - 2 * padding) /
        fitWidth) /
        log(2))
        .compareTo(log(180.0 /
        256.0 *
        (MediaQuery.of(context).size.height - 2 * padding) /
        fitHeight) /
        log(2)) <
        0
        ? log(360.0 /
        256.0 *
        (MediaQuery.of(context).size.width - 2 * padding) /
        fitWidth) /
        log(2)
        : log(180.0 /
        256.0 *
        (MediaQuery.of(context).size.height - 2 * padding) /
        fitHeight) /
        log(2);

    _mapLeaflet.mapController
        .move(LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2), fitZoom);
  }
}

void main() {
  runApp(MaterialApp(
    home: MapLeafletWidget(),
  ));
}
