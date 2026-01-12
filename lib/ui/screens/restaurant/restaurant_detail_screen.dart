import 'package:flutter/material.dart';
import '../../../domain/model/cart.dart';
import '../../../domain/model/food_item.dart';
import '../../../domain/model/restaurant.dart';
import '../../../domain/service/order_service.dart';
import '../../../data/repository/food_repository.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Cart cart;
  final OrderService orderService;
  final FoodRepository foodRepository;
  final ValueChanged<Cart>? onCartUpdated;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.cart,
    required this.orderService,
    required this.foodRepository,
    this.onCartUpdated,
  });

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Cart cart;
  late Future<List<FoodItem>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
    _foodsFuture = widget.foodRepository.getFoods(); 
  }

  void _addToCart(FoodItem food) {
    widget.orderService.addItem(cart, food);
    widget.onCartUpdated?.call(cart);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FoodItem>>(
      future: _foodsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final foods = widget.foodRepository.getFoodsByRestaurant(snapshot.data!, widget.restaurant);

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
                            const Icon(Icons.star, color: Colors.yellow, size: 18),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(food.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(food.description,
                                      style: const TextStyle(color: Colors.grey),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                Text('\$${food.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.orange,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.add, color: Colors.white),
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
      },
    );
  }
}
