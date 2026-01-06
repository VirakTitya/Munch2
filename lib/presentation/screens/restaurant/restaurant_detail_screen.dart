import 'package:flutter/material.dart';
import '../../mock/mock_food.dart';
import '../../../domain/entities/restaurant.dart';
import '../../state/cart_notifier.dart';
import '../../../domain/entities/cart_item.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final foods = mockFoods.where((f) => f.restaurant.id == restaurant.id).toList();

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Image.network(
                  restaurant.logoUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 12,
                top: 24,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '${restaurant.rating} (1000+)',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          restaurant.deliveryTime ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            food.imageUrl,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              const Text(
                                'Juicy beef patty with cheese, lettuce, tomato, and special sauce',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${food.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.orange,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () async {
                                  final existing = cartNotifier.value.items;
                                  final conflict = existing.isNotEmpty && existing.first.item.restaurant.id != food.restaurant.id;

                                  if (conflict) {
                                    final otherName = existing.first.item.restaurant.name;
                                    final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Clear cart?'),
                                            content: Text('Your cart contains items from "$otherName". Clear cart and add this item?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Clear & Add')),
                                            ],
                                          ),
                                        ) ??
                                        false;

                                    if (!confirmed) return;

                                    cartNotifier.clear();
                                  }

                                  try {
                                    cartNotifier.addItem(CartItem(item: food, quantity: 1));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Item added to cart')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
