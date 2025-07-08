// location_picker_screen.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({this.initialLocation, super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  final Location _locationService = Location();
  LatLng? _selectedLocation;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await _locationService.getLocation();
      setState(() {
        _currentLocation = location;
        if (_selectedLocation == null) {
          _selectedLocation = LatLng(
            location.latitude!,
            location.longitude!,
          );
          _mapController.move(_selectedLocation!, 15.0);
        }
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Restaurant Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedLocation),
          )
        ],
      ),
      body: _buildMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _selectedLocation ?? const LatLng(0, 0),
        initialZoom: 15.0,
        onTap: (_, point) => setState(() => _selectedLocation = point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.m3company.graduation_project',
        ),
        if (_selectedLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                width: 50.0,
                height: 50.0,
                point: _selectedLocation!,
                child:
                    const Icon(Icons.location_pin, color: Colors.red, size: 40),
              )
            ],
          ),
      ],
    );
  }
}
