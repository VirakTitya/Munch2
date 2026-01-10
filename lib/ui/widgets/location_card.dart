import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String address;
  final VoidCallback? onEdit;

  const LocationCard({
    super.key,
    required this.address,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.pin_drop, size: 18),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
