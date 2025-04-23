import 'package:flutter/material.dart';

class AppConstants {
  static const List<Map<String, dynamic>> serviceOptions = [
    {
      'title': 'Trip',
      'icon': Icons.directions_car,
      'isPromo': true,
    },
    {
      'title': 'Uber Auto',
      'icon': Icons.electric_rickshaw,
      'isPromo': true,
    },
    {
      'title': 'Intercity',
      'icon': Icons.directions_car_filled,
      'isPromo': false,
    },
    {
      'title': 'Courier',
      'icon': Icons.local_shipping,
      'isPromo': false,
    },
    {
      'title': 'Shuttle',
      'icon': Icons.directions_bus,
      'isPromo': false,
    },
    {
      'title': 'Rentals',
      'icon': Icons.car_rental,
      'isPromo': false,
    },
    {
      'title': 'Transit',
      'icon': Icons.train,
      'isPromo': false,
    },
    {
      'title': 'Reserve',
      'icon': Icons.event,
      'isPromo': false,
    },
  ];

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle serviceTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );
}
