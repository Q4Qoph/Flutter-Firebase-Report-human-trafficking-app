import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;

  MapScreen({required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  String? _selectedPlaceName;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _getPlaceName(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _selectedPlaceName = "${place.locality}, ${place.country}";
      });
      print("Selected place: $_selectedPlaceName");
    } catch (e) {
      print("Error fetching place name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null && _selectedPlaceName != null) {
                widget.onLocationSelected(
                    _selectedLocation!, _selectedPlaceName!);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a location')),
                );
              }
            },
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-1.2921, 36.8219), // Kenya coordinates
          zoom: 6,
        ),
        onMapCreated: (controller) {
          _controller = controller;
        },
        onTap: (location) {
          setState(() {
            _selectedLocation = location;
          });
          _getPlaceName(location);
        },
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _selectedLocation!,
                )
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: _getCurrentLocation,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        LatLng currentLocation = LatLng(position.latitude, position.longitude);
        _controller?.animateCamera(CameraUpdate.newLatLng(currentLocation));
        setState(() {
          _selectedLocation = currentLocation;
        });
        await _getPlaceName(currentLocation);
      } catch (e) {
        print("Error getting current location: $e");
      }
    } else {
      print("Location permission not granted");
    }
  }
}
