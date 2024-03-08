import 'package:supplychaintracking/Models/MapLeaflet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';


class MapLeafletService {



   void clearPosition(MapLeaflet mapLeaflet){
      mapLeaflet.markerPositions.clear();
      mapLeaflet.routeCoordinates.clear();
      mapLeaflet.distance = 0.0; // Clear distance
      mapLeaflet.duration = 0; // Clear duration
      mapLeaflet.durationString = "";
      mapLeaflet.distanceString = "";
   }






}