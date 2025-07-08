// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:graduation_project/presentation/owner/Menu_creation.dart/menu_creation_screen.dart';
import 'package:graduation_project/utils/services/image_upload_service.dart';
import 'package:graduation_project/utils/widgets/image_upload_widget.dart';

class RestaurantCreationScreen extends StatefulWidget {
  const RestaurantCreationScreen({super.key});

  @override
  _RestaurantCreationScreenState createState() =>
      _RestaurantCreationScreenState();
}

class _RestaurantCreationScreenState extends State<RestaurantCreationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _cuisineTypeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _sloganController = TextEditingController();
  final _experienceYearsController = TextEditingController();
  final _statusController = TextEditingController(text: 'active');
  final _categoriesController = TextEditingController();
  final List<String> _galleryImages = [];
  String? _logoBase64;
  String? _coverBase64;
  File? _logoImage;
  File? _coverImage;
  bool _isLoading = false;
  String? _ownerRestaurantName;
  String? _restaurantAddress;

  // New location variables
  LatLng? _selectedLocation;
  String? _geocodedAddress;

  @override
  void initState() {
    super.initState();
    _loadOwnerData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cuisineTypeController.dispose();
    _phoneController.dispose();
    _openingHoursController.dispose();
    _sloganController.dispose();
    _experienceYearsController.dispose();
    _statusController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  Future<void> _loadOwnerData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final ownerDoc =
          await _firestore.collection('owners').doc(user.uid).get();
      if (ownerDoc.exists) {
        setState(() {
          _ownerRestaurantName = ownerDoc.data()?['restaurantName'];
          _restaurantAddress = ownerDoc.data()?['restaurantAddress'];
        });
      } else {
        throw Exception("Owner document not found");
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Error loading owner data: $e',
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _logoImage = File(pickedFile.path);
        } else {
          _coverImage = File(pickedFile.path);
        }
      });
    }
  }

  // Open map location picker
  Future<void> _pickLocation() async {
    final location = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationPickerScreen(initialLocation: _selectedLocation),
      ),
    );

    if (location != null) {
      setState(() => _selectedLocation = location);
      await _reverseGeocode(location);
    }
  }

  // Convert coordinates to human-readable address
  Future<void> _reverseGeocode(LatLng position) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _geocodedAddress = data['display_name']);
      } else {
        setState(() => _geocodedAddress = "Address not found");
      }
    } catch (e) {
      setState(() => _geocodedAddress = "Error getting address");
      print("Reverse geocoding failed: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null || _ownerRestaurantName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing required information')),
      );
      return;
    }

    // Use geocoded address if available, otherwise fallback to owner's address
    final address = _geocodedAddress ?? _restaurantAddress ?? "Address not set";

    setState(() => _isLoading = true);

    try {
      final newRestaurant = {
        'name': _ownerRestaurantName,
        'address': address,
        'ownerId': user.uid,
        'description': _descriptionController.text,
        'cuisineType': _cuisineTypeController.text,
        'phone': _phoneController.text,
        'openingHours': _openingHoursController.text,
        'status': _statusController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'logoUrl': _logoBase64,
        'coverUrl': _coverBase64,
        'images': _galleryImages,
        'slogan': _sloganController.text,
        'experienceYears': int.tryParse(_experienceYearsController.text) ?? 0,
        'categories': _categoriesController.text.isNotEmpty
            ? _categoriesController.text.split(',')
            : [],
        'hours': {},
        'geolocation': _selectedLocation != null
            ? GeoPoint(
                _selectedLocation!.latitude,
                _selectedLocation!.longitude,
              )
            : null,
      };

      final docRef =
          await _firestore.collection('restaurants').add(newRestaurant);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuCreationScreen(restaurantId: docRef.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Restaurant'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_ownerRestaurantName != null) ...[
                    Text(
                      _ownerRestaurantName!,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // --- Images Section ---
                  Text('Images',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          ImageUploadWidget(
                            storagePath: 'restaurants/cover',
                            label: 'Cover Image',
                            onImageSelected: (base64) =>
                                setState(() => _coverBase64 = base64),
                          ),
                          const SizedBox(height: 12),
                          ImageUploadWidget(
                            storagePath: 'restaurants/logo',
                            label: 'Logo Image',
                            onImageSelected: (base64) =>
                                setState(() => _logoBase64 = base64),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: _galleryImages
                                .map((img) => ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(base64Decode(img),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text('Gallery Images',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () async {
                          final file = await ImageUploadService().pickImage();
                          if (file != null) {
                            final base64 =
                                await ImageUploadService().fileToBase64(file);
                            if (base64 != null) {
                              setState(() => _galleryImages.add(base64));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  // --- Location Section ---
                  const SizedBox(height: 24),
                  Text('Location',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant Location',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 10),
                          if (_geocodedAddress != null)
                            Text(
                              _geocodedAddress!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          if (_selectedLocation != null)
                            Text(
                              'Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          if (_geocodedAddress == null &&
                              _restaurantAddress != null)
                            Text(
                              _restaurantAddress!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text('Select on Map'),
                              onPressed: _pickLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Info Section ---
                  const SizedBox(height: 24),
                  Text('Info', style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  _buildTextField(
                      'Slogan', _sloganController, Icons.emoji_objects),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Description*', _descriptionController, Icons.description,
                      maxLines: 3),
                  const SizedBox(height: 16),
                  _buildTextField('Cuisine Type*', _cuisineTypeController,
                      Icons.restaurant_menu),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Contact Phone*', _phoneController, Icons.phone,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField('Opening Hours', _openingHoursController,
                      Icons.access_time),

                  // --- Details Section ---
                  const SizedBox(height: 24),
                  Text('Details',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  _buildTextField('Experience Years',
                      _experienceYearsController, Icons.school,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Status', _statusController, Icons.check_circle),
                  const SizedBox(height: 16),

                  // --- Categories as Chips ---
                  Text('Categories',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _categoriesController.text
                        .split(',')
                        .where((c) => c.trim().isNotEmpty)
                        .map((cat) => Chip(label: Text(cat.trim())))
                        .toList(),
                  ),
                  _buildTextField('Add Categories (comma separated)',
                      _categoriesController, Icons.category),
                  const SizedBox(height: 32),

                  // --- Submit Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _isLoading ? null : _createRestaurant,
                      label: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Continue to Menu Setup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (label.contains('*') && (value == null || value.isEmpty)) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}

// Location Picker Screen
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
      if (kDebugMode) {
        print("Error getting location: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Restaurant Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () => Navigator.pop(context, _selectedLocation),
          )
        ],
      ),
      body: _buildMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, color: Colors.white),
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
                    const Icon(Icons.location_pin, color: Colors.red, size: 50),
              )
            ],
          ),
      ],
    );
  }
}

void showErrorDialog(String title, String message, BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.rightSlide,
    title: title,
    desc: message,
    btnOkOnPress: () {},
  ).show();
}
