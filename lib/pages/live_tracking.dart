import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class LiveTrackingPage extends StatefulWidget {
  @override
  _LiveTrackingPageState createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  // Initial locations of 4 buses
  List<LatLng> busLocations = [
    LatLng(13.0827, 80.2707), // Bus 1 (Starting Point)
    LatLng(13.0104, 80.2150), // Bus 2
    LatLng(12.9716, 80.0453), // Bus 3
    LatLng(12.9237, 80.1172), // Bus 4
  ];

  // Simulating live movement of buses
  void _simulateBusMovement() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        busLocations = busLocations.map((bus) {
          double newLat = bus.latitude + (0.0005 - 0.001 * (busLocations.indexOf(bus) % 2));
          double newLng = bus.longitude + (0.0005 - 0.001 * (busLocations.indexOf(bus) % 2));
          return LatLng(newLat, newLng);
        }).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _simulateBusMovement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Bus Tracking"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(13.0827, 80.2707), // Chennai center point
          zoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: busLocations.map((bus) {
              return Marker(
                width: 50.0,
                height: 50.0,
                point: bus,
                child: Icon(Icons.directions_bus, color: Colors.red, size: 30),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
