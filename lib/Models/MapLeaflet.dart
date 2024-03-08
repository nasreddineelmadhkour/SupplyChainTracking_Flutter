import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapLeaflet {
  MapController _mapController = MapController();
  LatLng _currentPosition= LatLng(0, 0);
  List<LatLng> _markerPositions = [];
  List<LatLng> _routeCoordinates = [];
  double _distance = 0.0;
  String _durationString = '';
  String distanceString ='';
  int _duration = 0;
  List<String> _searchResults = [];
  bool _choiceSelected = false;
  String startingPoint='';
  String arrivalPoint='';


  // Getter for the mapController
  MapController get mapController => _mapController;

  // Getter and setter for the currentPosition
  LatLng get currentPosition => _currentPosition;
  set currentPosition(LatLng newPosition) {
    _currentPosition = newPosition;
  }

  // Getter for the markerPositions
  List<LatLng> get markerPositions => _markerPositions;

  // Getter and setter for the routeCoordinates
  List<LatLng> get routeCoordinates => _routeCoordinates;
  set routeCoordinates(List<LatLng> newCoordinates) {
    _routeCoordinates = newCoordinates;
  }

  // Getter and setter for the distance
  double get distance => _distance;
  set distance(double newDistance) {
    _distance = newDistance;
  }

  // Getter and setter for the durationString
  String get durationString => _durationString;
  set durationString(String newDurationString) {
    _durationString = newDurationString;
  }

  // Getter and setter for the duration
  int get duration => _duration;
  set duration(int newDuration) {
    _duration = newDuration;
  }

  // Getter and setter for the searchResults
  List<String> get searchResults => _searchResults;
  set searchResults(List<String> newResults) {
    _searchResults = newResults;
  }

  // Getter and setter for the choiceSelected
  bool get choiceSelected => _choiceSelected;
  set choiceSelected(bool newChoiceSelected) {
    _choiceSelected = newChoiceSelected;
  }

}
