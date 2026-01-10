import 'package:flutter/material.dart';
import 'package:munch2/data/mock/mock_food.dart';
import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/model/cart_item.dart';
import 'package:munch2/domain/model/food_item.dart';
import 'package:munch2/domain/model/restaurant.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Cart cart;
  final ValueChanged<Cart>? onCartUpdated;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.cart,
    this.onCartUpdated,
  });

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Cart cart;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
  }

  @override
  void didUpdateWidget(covariant RestaurantDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cart != oldWidget.cart) {
      cart = widget.cart;
    }
  }

  Future<void> _addToCart(FoodItem food) async {

    if (cart.items.isNotEmpty &&
        cart.items.first.food.restaurant.id != food.restaurant.id) {
      final otherName = cart.items.first.food.restaurant.name;

      final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Clear cart?'),
              content: Text(
                  'Your cart contains items from "$otherName". Clear cart and add this item?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Clear & Add')),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;

      setState(() {
        cart = Cart.empty();
      });
      widget.onCartUpdated?.call(cart);
    }

    setState(() {
      final existing = cart.items.firstWhere(
        (item) => item.food.id == food.id,
        orElse: () => CartItem(food: food, quantity: 0),
      );

      if (existing.quantity > 0) {
        existing.quantity++;
      } else {
        cart.items.add(CartItem(food: food));
      }
    });

    widget.onCartUpdated?.call(cart);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = mockFoods
        .where((f) => f.restaurant.id == widget.restaurant.id)
        .toList();

    return Scaffold(
      body: Column(
        children: [
          // Header
          Stack(
            children: [
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Image.network(
                  widget.restaurant.logoUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 12,
                top: 32,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
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
                      widget.restaurant.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.yellow, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          widget.restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Food list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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

                        // Food info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                food.description, // ✅ FIXED
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Price + add
                        Column(
                          children: [
                            Text(
                              '\$${food.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.orange,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.add,
                                    color: Colors.white),
                                onPressed: () => _addToCart(food),
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
