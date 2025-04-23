import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  _LocationSearchPageState createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  final LatLng _userLocation = LatLng(19.0760, 72.8777); // Default: Mumbai
  LatLng? _selectedLocation;

  List<Map<String, dynamic>> locationSuggestions = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    pickupController.addListener(() {
      _fetchLocationSuggestions(pickupController.text);
    });

    destinationController.addListener(() {
      _fetchLocationSuggestions(destinationController.text);
    });
  }

  Future<void> _fetchLocationSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        locationSuggestions.clear();
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=5");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> results = json.decode(response.body);

        setState(() {
          locationSuggestions = results
              .map((result) => {
                    "name": result["display_name"],
                    "latLng": LatLng(double.parse(result["lat"]),
                        double.parse(result["lon"])),
                  })
              .toList();
          isSearching = false;
        });
      }
    } catch (e) {
      print("Error fetching locations: $e");
      setState(() {
        isSearching = false;
      });
    }
  }

  void _selectLocation(LatLng location, String placeName) {
    setState(() {
      _selectedLocation = location;
      destinationController.text = placeName;
      locationSuggestions.clear(); // Hide suggestions after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Plan your ride"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(
                    "Pickup location", Icons.my_location, pickupController),
                const SizedBox(height: 10),
                _buildTextField("Drop-off location", Icons.location_on,
                    destinationController),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _userLocation,
                initialZoom: 13.0,
                onTap: (tapPosition, latLng) {
                  _selectLocation(latLng, "Custom Location");
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location,
                          color: Colors.blue, size: 30),
                    ),
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 30),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                if (isSearching)
                  const Center(child: CircularProgressIndicator()),
                for (var location in locationSuggestions)
                  _buildLocationTile(location["name"]!, location["latLng"]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildLocationTile(String title, LatLng location) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        _selectLocation(location, title);
      },
    );
  }
}
