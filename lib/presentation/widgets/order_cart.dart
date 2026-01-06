import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order? order;

  const OrderCard({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    
    // AI Generated
    final statusEnum = order?.status;
    final status = statusEnum != null ? statusEnum.toString().split('.').last : 'completed';
    final items = order?.items.length ?? 0;
    final date = DateTime.now();
    final total = (order?.totalPrice ?? 0.0) + 2.00;

    final restaurantName = order != null && order!.items.isNotEmpty
        ? order!.items.first.item.restaurant.name
        : 'Restaurant Name';

    // collect thumbnails (show up to 4, then indicate overflow)
    final thumbnails = <String>[];
    const maxThumbs = 4;
    final totalItems = order?.items.length ?? 0;
    if (order != null) {
      for (var i = 0; i < totalItems && thumbnails.length < maxThumbs; i++) {
        thumbnails.add(order!.items[i].item.imageUrl);
      }
    }
    final overflowCount = math.max(0, totalItems - thumbnails.length);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: title and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  restaurantName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                status[0].toUpperCase() + status.substring(1),
                style: TextStyle(
                  color: status == 'completed' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Middle row: thumbnails + meta info
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: thumbnails.isNotEmpty
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...thumbnails.map((url) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(url, width: 56, height: 56, fit: BoxFit.cover),
                              )),
                          if (overflowCount > 0)
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text('+$overflowCount', style: const TextStyle(color: Colors.black54)),
                            ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(width: 56, height: 56, color: Colors.grey[200]),
                      ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Item: $items', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text('${date.month}/${date.day}/${date.year}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              // Total aligned to the right
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 8),
                  Text('Total:', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
