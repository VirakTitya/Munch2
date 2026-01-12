import 'package:flutter/material.dart';
import '../../../domain/model/cart.dart';
import '../../../domain/model/food_item.dart';
import '../../../domain/service/order_service.dart';
import '../../../data/repository/food_repository.dart';
import '../../widgets/food_feed_card.dart';

class HomeScreen extends StatefulWidget {
  final Cart cart;
  final OrderService orderService;
  final FoodRepository foodRepository;
  final ValueChanged<Cart>? onCartUpdated;
  final VoidCallback? onGoToOrders;

  const HomeScreen({
    super.key,
    required this.cart,
    required this.orderService,
    required this.foodRepository,
    this.onCartUpdated,
    this.onGoToOrders,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Cart cart;
  late Future<List<FoodItem>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
    _foodsFuture = widget.foodRepository.getFoods();
  }

  String? _cartRestaurantId() {
    if (cart.items.isEmpty) return null; 
    return cart.items.first.food.restaurant.id;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool?> _showReplaceDialog(FoodItem food) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace cart items?'),
        content: Text(
          'Your cart has items from another restaurant.\n'
          'Clear the cart and add "${food.name}" from ${food.restaurant.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReplaceAndAdd(FoodItem food) async {
    final confirmed = await _showReplaceDialog(food);
    if (confirmed != true) return; 

    widget.orderService.clearCart(cart);
    widget.orderService.addItem(cart, food);
    widget.onCartUpdated?.call(cart);
    _showMessage('Cart replaced and item added');
  }

  void _addToCart(FoodItem food) {
    final currentRestaurantId = _cartRestaurantId();
    final newRestaurantId = food.restaurant.id;

    if (currentRestaurantId != null && currentRestaurantId != newRestaurantId) {
      _confirmReplaceAndAdd(food);
      return;
    }

    widget.orderService.addItem(cart, food);
    widget.onCartUpdated?.call(cart);
    _showMessage('Item added to cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<FoodItem>>(
        future: _foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Failed to load foods: ${snapshot.error}'),
              ),
            );
          }

          final foods = snapshot.data ?? [];
          if (foods.isEmpty) {
            return const Center(child: Text('No food items available'));
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return FoodFeedCard(
                food: food,
                onAddToCart: () => _addToCart(food),
              );
            },
          );
        },
      ),
    );
  }
}
