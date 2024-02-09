import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class MapboxWidget extends StatelessWidget {
  final String accessToken = 'sk.eyJ1IjoibmFzcmVkZGluZTEyMzQiLCJhIjoiY2xzZGE5MDcwMHE1MTJrbzVhdjNpcXVtYSJ9.KmiLERK7bwZtVG58zjq0qA'; // Replace with your Mapbox access token

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: accessToken,
      styleString: MapboxStyles.MAPBOX_STREETS,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.7749, -122.4194), // Initial map center coordinates
        zoom: 13.0, // Initial zoom level
      ),
    );
  }
}