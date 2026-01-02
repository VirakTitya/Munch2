import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';

class FoodFeedCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onAddToCart;

  const FoodFeedCard({
    super.key,
    required this.food,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.network(
          food.imageUrl,
          fit: BoxFit.cover,
        ),

        // Gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black87,
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                food.restaurant.name,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
