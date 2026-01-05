import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order? order;

  const OrderCard({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    
    // AI generated placeholder data
    final displayId = order?.id ?? 'Order #12345';
    final status = order?.status.toString().split('.').last ?? 'delivered';
    final items = order?.items.length ?? 3;
    final date = DateTime.now();
    final total = order?.totalPrice ?? 24.5;

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
          // Order ID + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: status == 'delivered' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '$items items',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${date.month}/${date.day}/${date.year}',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
