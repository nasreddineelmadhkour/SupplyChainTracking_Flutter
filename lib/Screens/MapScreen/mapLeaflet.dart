import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MapLeafletWidget extends StatefulWidget {
  @override
  _MapLeafletWidgetState createState() => _MapLeafletWidgetState();
}

class _MapLeafletWidgetState extends State<MapLeafletWidget> with TickerProviderStateMixin {
  MapController mapController = MapController();
  LatLng? _currentPosition;
  List<LatLng> _markerPositions = [];
  List<LatLng> _routeCoordinates = [];
  double _distance = 0.0;
  int _duration = 0;
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
      _currentPosition = LatLng(position.latitude, position.longitude);

      if (_currentPosition != null) {
        _animateToPosition(_currentPosition!, 15.0);
      }
    });
  }

  void _animateToPosition(LatLng position, double zoom) {
    final center = mapController.center;
    final startZoom = mapController.zoom;

    final interval = 0.01;
    final distance = Geolocator.distanceBetween(center.latitude, center.longitude, position.latitude, position.longitude);
    final duration = Duration(milliseconds: (interval * distance).toInt());

    final curve = Curves.easeInOut;

    final zoomTween = Tween<double>(begin: startZoom, end: zoom);
    final centerTween = LatLngTween(begin: center, end: position);

    AnimationController animationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    final animation = CurvedAnimation(parent: animationController, curve: curve);

    animation.addListener(() {
      final zoomValue = zoomTween.evaluate(animation);
      final centerValue = centerTween.evaluate(animation);
      mapController.move(centerValue, zoomValue);
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
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
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
                    points: _routeCoordinates,
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
                onChanged: _updateSearchResults,
                onSubmitted: (_) => _searchAddress(),
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
                  children: _searchResults.map((result) {
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

    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: _currentPosition!,
          width: 40,
          height: 40,
          child: Image.asset("assets/images/maps/myposition.png"),
        ),
      );
    }

    for (var i = 0; i < _markerPositions.length; i++) {
      markers.add(
        Marker(
          point: _markerPositions[i],
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _markerPositions.removeAt(i);
              });
            },
            child: i == 0
                ? Image.asset("assets/images/maps/Pick_destination.png")
                : Image.asset("assets/images/maps/Pick_arrival.png"),
          ),
        ),
      );
    }

    if (_routeCoordinates.isNotEmpty && _distance > 0 && _duration > 0) {
      int hours = _duration ~/ 60;
      int remainingMinutes = _duration % 60;

      String durationString = '';
      if (hours > 0) {
        durationString += '$hours ';
        if (hours == 1) {
          durationString += 'hour ';
        } else {
          durationString += 'hours ';
        }
      }
      if (remainingMinutes > 0) {
        durationString += '$remainingMinutes ';
        if (remainingMinutes == 1) {
          durationString += 'minute';
        } else {
          durationString += 'minutes';
        }
      }

      markers.add(
        Marker(
          point: _routeCoordinates.last,
          width: 160,
          height: 60,
          child: Column(
            children: [
              Text(
                "Distance: ${_distance.toStringAsFixed(2)} KM",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Duration: $durationString",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return markers;
  }

  void _handleTapOnMap(TapPosition tapPosition, LatLng tappedPosition) {
    if (_markerPositions.length < 2) {
      setState(() {
        _markerPositions.add(tappedPosition);
      });

      if (_markerPositions.length == 2) {
        _getRouteCoordinates();
      }
    } else {
      setState(() {
        _markerPositions.clear();
        _routeCoordinates.clear();
      });
    }
  }

  void _getRouteCoordinates() async {
    String accessToken = 'sk.eyJ1IjoibmFzcmVkZGluZTEyMzQiLCJhIjoiY2xzZGE5MDcwMHE1MTJrbzVhdjNpcXVtYSJ9.KmiLERK7bwZtVG58zjq0qA';
    LatLng origin = _markerPositions[0];
    LatLng destination = _markerPositions[1];

    String url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?alternatives=false&geometries=geojson&steps=true&access_token=$accessToken';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> geometry = data['routes'][0]['geometry']['coordinates'];

      List<LatLng> coordinates = geometry.map((coord) {
        double lat = coord[1];
        double lng = coord[0];
        return LatLng(lat, lng);
      }).toList();

      double distance = data['routes'][0]['distance'] / 1000;
      int duration = data['routes'][0]['duration'] ~/ 60;

      setState(() {
        _routeCoordinates = coordinates;
        _distance = distance;
        _duration = duration;
      });

      _adjustZoomToFit();
    } else {
      print('Failed to fetch route coordinates');
    }
  }

  bool _choiceSelected = false;

  void _updateSearchResults(String value) async {
    setState(() {
      _searchResults.clear();
      _choiceSelected = false; // Reset the flag
    });

    if (value.isEmpty) {
      return; // Exit function if search value is empty
    }

    try {
      List<Location> locations = await locationFromAddress(value);
      Set<String> uniqueResults = {}; // Set to store unique addresses

      for (Location location in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String subadministrativearea = placemark.name ?? '';
          String subLocality = placemark.subLocality ?? '';
          String administrativeArea = placemark.administrativeArea ?? '';
          String country = placemark.country ?? '';

          // Check if the country is Tunisia before adding to the search results
          if (country.toLowerCase() == 'tunisie') {
            uniqueResults.add('$subadministrativearea $subLocality, $administrativeArea, $country');
          }
        }
      }

      setState(() {
        _searchResults.addAll(uniqueResults.toList());
      });
    } catch (e) {
      print('Error fetching search results: $e');
    }
  }

  void _handleSearchResultTap(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng tappedPosition = LatLng(location.latitude, location.longitude);

        setState(() {
          _markerPositions.clear();
          _routeCoordinates.clear();
          _markerPositions.add(tappedPosition);
        });

        if (_choiceSelected || _markerPositions.length == 2) {
          _getRouteCoordinates();
        } else {
          _animateToPosition(tappedPosition, 15.0);
        }
      }
    } catch (e) {
      print('Error handling search result tap: $e');
    }
  }


  void _searchAddress() {
    if (_searchResults.isNotEmpty) {
      _handleSearchResultTap(_searchResults.first);
    }
  }

  void _adjustZoomToFit() {
    List<LatLng> allCoordinates = [..._markerPositions, ..._routeCoordinates];

    double minLat = allCoordinates.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = allCoordinates.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = allCoordinates.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = allCoordinates.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

    double fitWidth = maxLng - minLng;
    double fitHeight = maxLat - minLat;

    double padding = 50;

    double fitZoom = (log(360.0 / 256.0 * (MediaQuery.of(context).size.width - 2 * padding) / fitWidth) / log(2))
        .compareTo(log(180.0 / 256.0 * (MediaQuery.of(context).size.height - 2 * padding) / fitHeight) / log(2)) < 0
        ? log(360.0 / 256.0 * (MediaQuery.of(context).size.width - 2 * padding) / fitWidth) / log(2)
        : log(180.0 / 256.0 * (MediaQuery.of(context).size.height - 2 * padding) / fitHeight) / log(2);

    mapController.move(LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2), fitZoom);
  }
}

void main() {
  runApp(MaterialApp(
    home: MapLeafletWidget(),
  ));
}
