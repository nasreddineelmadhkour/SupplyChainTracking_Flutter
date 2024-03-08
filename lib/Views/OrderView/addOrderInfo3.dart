import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:supplychaintracking/Models/StaticMethode.dart';
import 'package:supplychaintracking/Services/MapLeafletService.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:supplychaintracking/ViewModel/MapOpenStreatViewModel.dart';

class AddOrderInfo3 extends StatefulWidget {
  @override
  _AddOrderInfo3 createState() => _AddOrderInfo3();
}

class _AddOrderInfo3 extends State<AddOrderInfo3> with TickerProviderStateMixin {
  MapLeaflet _mapLeaflet = MapLeaflet();
  MapLeafletService _mapLeafletService = MapLeafletService();
  Timer? _searchTimer;
  List<String> _searchResults = [];

  MapOpenStreatViewModel mapOpenStreatViewModel = MapOpenStreatViewModel();


  late TextEditingController _startingPointController = TextEditingController();
  late TextEditingController _arrivalPointController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              color: Colors.grey.withOpacity(.3),
              borderRadius: BorderRadius.circular(15)),
          child: TextFormField(
            controller: _searchController,
            focusNode: _searchFocusNode,

            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            onFieldSubmitted: (value) => _searchAddress(value),
            onChanged: (value) =>
                _updateSearchResults(value), // Update this line
          ),
        ),
        if (_searchFocusNode.hasFocus)
          Container(
            margin: EdgeInsets.only(),
            child: Card(
              elevation: 4,
              color: Colors.white, // Set the background color to white
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.teal, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < _mapLeaflet.searchResults.length; i++)
                    Column(
                      children: [
                        ListTile(
                          title: Text(_mapLeaflet.searchResults[i]),
                          onTap: () {
                            _handleSearchResultTap(_mapLeaflet.searchResults[i]);
                          },
                        ),
                        if (i < _mapLeaflet.searchResults.length - 1)
                          Divider(height: 1, color: Colors.teal), // Add Divider between items
                      ],
                    ),
                ],
              ),
            ),
          ),

        SizedBox(height: 5),
        Container(
          height: 600, // Adjust the height as needed
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMap(
              mapController: _mapLeaflet.mapController,
              options: MapOptions(
                center: LatLng(34.0812055063, 9.417373468231718),
                zoom: 6.7,
                onLongPress: _handleTapOnMap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                  subdomains: ['a', 'b', 'c'],
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
          ),
        ),
        Container(
          color: Color.fromRGBO(255, 255, 255, 0.5),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the content vertically
            children: [
              Icon(
                Icons.access_time, // Choose the appropriate icon
                color: Colors.green,
                size: 30,
              ),
              SizedBox(width: 10), // Add some space between icon and text
              Text(
                "${_mapLeaflet.durationString}",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 10), // Add some space between icon and text

              Text(
                "${_mapLeaflet.distanceString}",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              )
              ,SizedBox(width: 10), // Add some space between icon and text
              Icon(
                FontAwesomeIcons.truckMoving, // Choose the appropriate icon
                color: Colors.grey,
                size: 30,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              color: Colors.grey.withOpacity(.3),
              borderRadius: BorderRadius.circular(15)),
          child: TextFormField(
            controller: _startingPointController,
            decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.arrowRight),
                hintText: "Starting point",
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              color: Colors.grey.withOpacity(.3),
              borderRadius: BorderRadius.circular(15)),
          child: TextFormField(
            controller: _arrivalPointController,
            decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.arrowLeft),
                hintText: "Arrival point",
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 15),
      ],
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
      if(i==0){
        StaticMethode.staticOrder.startingLong=_mapLeaflet.markerPositions[i].longitude;
        StaticMethode.staticOrder.startingLat=_mapLeaflet.markerPositions[i].latitude;

        print("StartingPoint : Lat:"+ StaticMethode.staticOrder.startingLat.toString()+" Long: "+StaticMethode.staticOrder.startingLong.toString());

      }
      if(i==1){
        StaticMethode.staticOrder.arrivalLong=_mapLeaflet.markerPositions[i].longitude;
        StaticMethode.staticOrder.arrivalLat=_mapLeaflet.markerPositions[i].latitude;
        print("ArrivalPoint : Lat:"+ StaticMethode.staticOrder.arrivalLat.toString()+" Long: "+StaticMethode.staticOrder.arrivalLong.toString());

      }
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

                if(i==0){


                  _startingPointController.text=_arrivalPointController.text;
                  _arrivalPointController.text="";
                  StaticMethode.staticOrder.startingLat=0;
                  StaticMethode.staticOrder.startingLong=0;
                  print("StartingPoint : Lat:"+ StaticMethode.staticOrder.startingLat.toString()+" Long: "+StaticMethode.staticOrder.startingLong.toString());

                }
                if(i==1){
                 // _startingPointController.text=_arrivalPointController.text;
                  _arrivalPointController.text="";

                  StaticMethode.staticOrder.arrivalLong=0;
                  StaticMethode.staticOrder.arrivalLat=0;
                  print("ArrivalPoint : Lat:"+ StaticMethode.staticOrder.arrivalLat.toString()+" Long: "+StaticMethode.staticOrder.arrivalLong.toString());

                }
              });
            },
            child: i == 0
                ? Image.asset("assets/images/maps/Pick_destination.png")
                : Image.asset("assets/images/maps/Pick_arrival.png"),
          ),
        ),
      );
    }

    if (_mapLeaflet.markerPositions.isNotEmpty && _mapLeaflet.routeCoordinates.isNotEmpty
        && _mapLeaflet.distance > 0 && _mapLeaflet.duration >= 0)
    {
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

      StaticMethode.staticOrder.estimation= _mapLeaflet.durationString;
      print(StaticMethode.staticOrder.estimation);

    }

    return markers;
  }

  Future<void> _handleTapOnMap(TapPosition tapPosition, LatLng tappedPosition) async {
    if (_mapLeaflet.markerPositions.length < 2) {
        String fullAddress="";

        if(await mapOpenStreatViewModel.getFullAddress(
            '${tappedPosition.latitude},${tappedPosition.longitude}'))
          {
            fullAddress=mapOpenStreatViewModel.address.text;
          }

        setState(() {
          _mapLeaflet.markerPositions.add(tappedPosition);
          if (fullAddress != "" && _mapLeaflet.markerPositions.length==1) {
            _startingPointController.text = fullAddress;
          }
          if (fullAddress != "" && _mapLeaflet.markerPositions.length==2) {
            _arrivalPointController.text = fullAddress;
            _getRouteCoordinates();
          }
        });
/*
        if (_mapLeaflet.markerPositions.length == 2) {

        }*/

    } else {
      setState(() {
        _mapLeaflet.markerPositions.clear();
        _mapLeaflet.routeCoordinates.clear();
        _mapLeaflet.distance = 0.0; // Clear distance
        _mapLeaflet.duration = 0; // Clear duration
        _mapLeaflet.durationString = "";
        _mapLeaflet.distanceString = "";
        _startingPointController.text = "";
        _arrivalPointController.text = "";
      });
      StaticMethode.staticOrder.distance = "";
      StaticMethode.staticOrder.estimation = "";
      print(StaticMethode.staticOrder.estimation);
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
      StaticMethode.staticOrder.distance = _mapLeaflet.distanceString;
      print(StaticMethode.staticOrder.distance);
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

    // Cancel previous timer if any
    if (_searchTimer != null && _searchTimer!.isActive) {
      _searchTimer!.cancel();
    }

    // Create a new timer with a delay of 2 seconds
    _searchTimer = Timer(Duration(seconds: 1), () async {
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

          for (var location in data) {
            // Extract relevant address components
            String amenity = location['address']['amenity'] ?? '';
            String name = location['address']['name'] ?? '';
            String state = location['address']['state'] ?? '';
            String county = location['address']['county'] ?? '';

            uniqueResults.add(location['display_name']);
          }

          setState(() {
            _mapLeaflet.searchResults.clear();
            for (String chaine in uniqueResults) {
              _mapLeaflet.searchResults.add(chaine);
            }
          });
        } else {
          // Handle the error if the request was not successful
          print('Error fetching search results: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any other errors
        print('Error fetching search results: $e');
      }
    });
  }

  void _handleSearchResultTap(String address) async {
    try {
      // Construct the search query
      String url =
          'https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1&countrycodes=TN&accept-language=fr';

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

          String fulladdress = data[0]['display_name'];
          LatLng tappedPosition = LatLng(latitude, longitude);



          setState(() {
            _startingPointController.text=fulladdress;
            _searchController.text = fulladdress;
            _searchFocusNode.unfocus();
            _mapLeaflet.markerPositions.clear();
            _mapLeaflet.routeCoordinates.clear();
            _mapLeaflet.durationString="";
            _mapLeaflet.distanceString="";
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
}
