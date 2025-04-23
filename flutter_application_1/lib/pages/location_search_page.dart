import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class RideOption {
  final String name;
  final IconData icon;
  final double baseFare;
  final double costPerKm;
  final int estimatedTime;
  final double totalCost;

  RideOption({
    required this.name,
    required this.icon,
    required this.baseFare,
    required this.costPerKm,
    required this.estimatedTime,
    required this.totalCost,
  });
}

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
  bool isPickupFocused = false;

  List<Map<String, dynamic>> locationSuggestions = [];
  bool isSearching = false;
  List<RideOption> rideOptions = [];
  double? calculatedDistance;
  bool showRideOptions = false;

  double calculateDistance(LatLng start, LatLng end) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = cos;
    var a = 0.5 -
        c((end.latitude - start.latitude) * p) / 2 +
        c(start.latitude * p) *
            c(end.latitude * p) *
            (1 - c((end.longitude - start.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  void updateRideOptions() {
    if (_selectedLocation == null) return;

    double distance = calculateDistance(_userLocation, _selectedLocation!);
    setState(() {
      calculatedDistance = distance;
      rideOptions = [
        RideOption(
          name: 'Bike',
          icon: Icons.motorcycle,
          baseFare: 20,
          costPerKm: 12,
          estimatedTime: (distance * 3).round(),
          totalCost: 20 + (distance * 12),
        ),
        RideOption(
          name: 'Auto',
          icon: Icons.electric_rickshaw,
          baseFare: 30,
          costPerKm: 15,
          estimatedTime: (distance * 3.5).round(),
          totalCost: 30 + (distance * 15),
        ),
        RideOption(
          name: 'Car',
          icon: Icons.car_rental,
          baseFare: 50,
          costPerKm: 20,
          estimatedTime: (distance * 4).round(),
          totalCost: 50 + (distance * 20),
        ),
        RideOption(
          name: 'Premier',
          icon: Icons.car_crash,
          baseFare: 100,
          costPerKm: 25,
          estimatedTime: (distance * 4).round(),
          totalCost: 100 + (distance * 25),
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();

    pickupController.addListener(() {
      if (isPickupFocused) {
        _fetchLocationSuggestions(pickupController.text);
      }
    });

    destinationController.addListener(() {
      if (!isPickupFocused) {
        _fetchLocationSuggestions(destinationController.text);
      }
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
      updateRideOptions(); // Calculate ride options when location is selected
    });
  }

  void _handleBookRide() {
    setState(() {
      showRideOptions = true;
      locationSuggestions.clear();
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
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      isPickupFocused = hasFocus;
                      if (hasFocus) {
                        showRideOptions = false;
                      }
                    });
                  },
                  child: _buildTextField(
                    "Pickup location",
                    Icons.my_location,
                    pickupController,
                  ),
                ),
                const SizedBox(height: 10),
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      isPickupFocused = false;
                      if (hasFocus) {
                        showRideOptions = false;
                      }
                    });
                  },
                  child: _buildTextField(
                    "Drop-off location",
                    Icons.location_on,
                    destinationController,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: pickupController.text.isNotEmpty &&
                            destinationController.text.isNotEmpty
                        ? _handleBookRide
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Book Ride',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                FlutterMap(
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
                if (_selectedLocation != null && showRideOptions)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'Distance: ${calculatedDistance?.toStringAsFixed(2)} km',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isSearching)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (locationSuggestions.isNotEmpty && !showRideOptions)
            Expanded(
              child: ListView(
                children: [
                  for (var location in locationSuggestions)
                    _buildLocationTile(location["name"]!, location["latLng"]),
                ],
              ),
            )
          else if (showRideOptions && _selectedLocation != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Choose a ride',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rideOptions.length,
                        itemBuilder: (context, index) {
                          final option = rideOptions[index];
                          return ListTile(
                            leading: Icon(option.icon, size: 32),
                            title: Text(option.name),
                            subtitle: Text('${option.estimatedTime} min'),
                            trailing: Text(
                              '₹${option.totalCost.round()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${option.name} ride selected!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
