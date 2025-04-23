import 'package:flutter/material.dart';
import 'location_search_page.dart';
import 'services_page.dart';
import 'carbon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../constants/app_constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.black),
              const SizedBox(width: 8),
              const Text("Rides", style: TextStyle(color: Colors.black)),
              const Spacer(),
              const Icon(Icons.sports_football, color: Colors.black),
              const SizedBox(width: 8),
              const Text("Eats", style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 16),
            _buildTravelOptions(),
            const SizedBox(height: 24),
            _buildSection("Ride as you like it", _buildRideOptions()),
            _buildSection("Commute smarter", _buildCommuteOptions()),
            _buildPromoSection(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LocationSearchPage()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 8),
            Expanded(
              child: Text("Where to?",
                  style: TextStyle(color: Colors.black54, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: AppConstants.serviceOptions
          .take(4)
          .map((option) => _buildOption(option['icon'], option['title']))
          .toList(),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 36, color: Colors.black),
        const SizedBox(height: 4),
        Text(text, style: AppConstants.serviceTitleStyle),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppConstants.sectionTitleStyle),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildRideOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRideOption(
              "Book Uber Auto", "assets/Uber_Auto_558x372_pixels_Desktop.jpg"),
          _buildRideOption("Book Uber XL",
              "assets/360_F_1177342225_4nqBSE2JARmL00zOaj6LsDKlnoRzeSAf.jpg"),
          _buildRideOption("Book Rental",
              "assets/360_F_481296102_MFYiHxLkrLSRXF5vTth0ZGbdPkn8yCSU.jpg"),
          _buildRideOption("Book Premier",
              "assets/223-2238120_uber-select-png-transparent-png.png"),
        ],
      ),
    );
  }

  Widget _buildCommuteOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRideOption("Go with Uber Auto",
              "assets/Uber_Auto_558x372_pixels_Desktop.jpg"),
          _buildRideOption("Hop on a Shuttle",
              "assets/360_F_1177342225_4nqBSE2JARmL00zOaj6LsDKlnoRzeSAf.jpg"),
        ],
      ),
    );
  }

  Widget _buildRideOption(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Ready? Then let's roll.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: AppConstants.primaryButtonStyle,
            child: const Text("Ride with Uber"),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarbonPage()),
      );
    }
  }
}
