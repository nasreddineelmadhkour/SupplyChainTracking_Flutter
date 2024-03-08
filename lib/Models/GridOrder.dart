import 'dart:ui';

import 'package:supplychaintracking/Models/MapLeaflet.dart';


class GridOrder{
  MapLeaflet mapLeaflet = MapLeaflet();
  String name;
  VoidCallback onTap;
  Color backgroundColor; // New property to store the background color

  GridOrder({
    required this.mapLeaflet,
    required this.name,
    required this.onTap,
    required this.backgroundColor,

  });

}