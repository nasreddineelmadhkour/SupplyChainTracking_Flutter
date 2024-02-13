import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
      : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    final double lat = lerpDouble(begin!.latitude, end!.latitude, t)!;
    final double lng = lerpDouble(begin!.longitude, end!.longitude, t)!;
    return LatLng(lat, lng);
  }
}