import 'package:flutter/material.dart';

class MockLocation {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String value;

  const MockLocation({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
  });
}

const mockLocations = [
  MockLocation(
    icon: Icons.my_location,
    color: Colors.green,
    title: 'Use Current Location',
    subtitle: "We'll detect your location automatically",
    value: 'Current Location',
  ),
  MockLocation(
    icon: Icons.home,
    color: Colors.green,
    title: 'Home',
    subtitle: 'Toul Kork,Phnom Penh',
    value: 'Home • Toul Kork Phnom Penh',
  ),
  MockLocation(
    icon: Icons.work,
    color: Colors.orange,
    title: 'Office',
    subtitle: 'Bellevue, WA',
    value: 'Office • Bellevue, WA',
  ),
];
