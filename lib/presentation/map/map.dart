// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  LatLng? latlongget;
  MapScreen({super.key, this.latlongget});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final Location _location = Location();

  LocationData? _currentLocation;
  final List<Marker> _markers = [];
  final List<LatLng> _savedMarkers = [];
  bool _isSearching = false;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();

    // If a location is passed, go to it
    if (widget.latlongget != null) {
      Future.microtask(() {
        _moveToPassedLatLng(widget.latlongget!);
      });
    } else {
      _getCurrentLocation();
    }
  }

  void _moveToPassedLatLng(LatLng latLng) {
    setState(() {
      _markers.add(
        Marker(
          width: 50.0,
          height: 50.0,
          point: latLng,
          child: const Icon(Icons.location_on, color: Colors.red, size: 35.0),
        ),
      );
    });

    _mapController.move(latLng, 16.0);
  }

  Future<void> _initLocationService() async {
    _hasLocationPermission = await _checkLocationPermission();
    if (_hasLocationPermission) {
      _getCurrentLocation();
    } else {
      _showErrorDialog("Location permission denied");
    }
  }

  Future<bool> _checkLocationPermission() async {
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }
    return permission == PermissionStatus.granted;
  }

  Future<void> _getCurrentLocation() async {
    final userLocation = await _location.getLocation();
    _updateUserLocation(userLocation);
    _location.onLocationChanged.listen(_updateUserLocation);
  }

  void _updateUserLocation(LocationData userLocation) {
    if (!mounted) return;

    setState(() {
      _currentLocation = userLocation;
      // Update or add user location marker
      _markers.removeWhere((m) =>
          m.child is Icon && (m.child as Icon).icon == Icons.my_location);
      _markers.add(
        Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(userLocation.latitude!, userLocation.longitude!),
          child: const Icon(Icons.my_location, color: Colors.blue, size: 35.0),
        ),
      );
    });
    _mapController.move(
      LatLng(userLocation.latitude!, userLocation.longitude!),
      _mapController.camera.zoom,
    );
  }

  void _updateMarkers(LatLng position, IconData icon, Color color) {
    setState(() {
      _markers.add(
        Marker(
          width: 50.0,
          height: 50.0,
          point: position,
          child: Icon(icon, color: color, size: 35.0),
        ),
      );
      _mapController.move(position, 15.0);
    });
  }

  Future<void> _searchLocation(String locationName) async {
    if (locationName.trim().isEmpty) {
      _showErrorDialog("Please enter a location to search.");
      return;
    }

    setState(() => _isSearching = true);

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$locationName&format=json&addressdetails=1&limit=1',
      );

      final response = await http.get(uri, headers: {
        'User-Agent':
            'com.m3company.graduation_project/1.0 (https://github.com/keronabil)'
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat']);
          final lon = double.tryParse(data[0]['lon']);

          if (lat != null && lon != null) {
            final searchResult = LatLng(lat, lon);

            // Remove old search markers (optional)
            _markers.removeWhere((m) =>
                m.child is Icon && (m.child as Icon).color == Colors.red);

            _updateMarkers(searchResult, Icons.location_on, Colors.red);

            // Smooth camera movement
            _mapController.move(searchResult, 16.0);

            // Feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location found: $locationName')),
            );
          } else {
            _showErrorDialog("Invalid coordinates returned.");
          }
        } else {
          _showErrorDialog("No results found for \"$locationName\".");
        }
      } else {
        _showErrorDialog(
            "Server error: ${response.statusCode}. Try again later.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: ${e.toString()}");
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _saveMarker() {
    if (_markers.isNotEmpty) {
      setState(() {
        _savedMarkers.add(_markers.last.point);
      });
      _showSuccessDialog("Marker saved successfully!");
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Oops!',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Screen", style: TextStyle(color: Colors.white)),
        elevation: 1.0,
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () =>
                                  _searchLocation(_searchController.text),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    onSubmitted: (query) => _searchLocation(query),
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      initialZoom: 15.0,
                      onTap: (_, point) => _updateMarkers(
                          point, Icons.location_on, Colors.deepOrange),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        tileProvider: NetworkTileProvider(),
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'save_marker',
            backgroundColor: Colors.green,
            onPressed: _saveMarker,
            child: const Icon(Icons.save, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'my_location',
            backgroundColor: Colors.orange,
            onPressed: () {
              if (_currentLocation != null) {
                _mapController.move(
                    LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    15.0);
              }
            },
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
