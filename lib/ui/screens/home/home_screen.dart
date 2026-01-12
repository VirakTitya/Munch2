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
    _foodsFuture = widget.foodRepository.getFoods(); // load JSON
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<FoodItem>>(
        future: _foodsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final foods = snapshot.data!;

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
