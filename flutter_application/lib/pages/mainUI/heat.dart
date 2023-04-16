import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<WeightedLatLng> _pins = {};
  final Set<Heatmap> _heatmaps = {};
  LatLng _pinLocation; // Added

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        heatmaps: _heatmaps,
        markers: _buildMarkers(), // Added
        onTap: _addPin,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  void _addPin(LatLng latLng) {
    setState(() {
      _pinLocation = latLng;
    });
  }

  Set<Marker> _buildMarkers() {
    if (_pinLocation == null) {
      return {};
    }
    return {
      Marker(
        markerId: MarkerId('pin'),
        position: _pinLocation,
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          setState(() {
            _pinLocation = newPosition;
          });
        },
        onTap: () {
          _showConfirmationDialog(_pinLocation);
        }, // Add this line
      ),
    };
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  Heatmap _createHeatmap() {
    return Heatmap(
      heatmapId: HeatmapId('heatmap'),
      points: _pins.toList(),
    );
  }

  void _showConfirmationDialog(LatLng latLng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Do you want to mark this location unsafe?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Drop Pin"),
              onPressed: () {
                setState(() {
                  _pins.add(_createWeightedLatLng(
                      latLng.latitude, latLng.longitude, 1));
                  _heatmaps.clear();
                  _heatmaps.add(_createHeatmap());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
