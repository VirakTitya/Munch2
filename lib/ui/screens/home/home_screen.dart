import 'package:flutter/material.dart';
import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/model/cart_item.dart';
import 'package:munch2/domain/model/food_item.dart';
import 'package:munch2/ui/widgets/food_feed_card.dart';
import 'package:munch2/ui/screens/cart/cart_screen.dart';
import 'package:munch2/data/mock/mock_food.dart';

class HomeScreen extends StatefulWidget {
  final Cart cart;
  final ValueChanged<Cart>? onCartUpdated;
  final VoidCallback? onGoToOrders;

  const HomeScreen({
    super.key,
    required this.cart,
    this.onCartUpdated,
    this.onGoToOrders,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Cart cart;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cart != oldWidget.cart) {
      setState(() {
        cart = widget.cart;
      });
    }
  }

  void _addToCart(FoodItem food) async {
    // Check for restaurant conflict
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
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Clear & Add')),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;
      setState(() {
        cart = Cart.empty(); // Clear cart
      });
      widget.onCartUpdated?.call(cart);
    }

    // Add item to cart
    setState(() {
      final existing = cart.items
          .firstWhere((item) => item.food.id == food.id, orElse: () => CartItem(food: food, quantity: 0));
      if (existing.quantity > 0) {
        existing.quantity++;
      } else {
        cart.items.add(CartItem(food: food, quantity: 1));
      }
    });

    widget.onCartUpdated?.call(cart);

    // Show snack bar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Item added to cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.green,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CartScreen(
                    cart: cart,
                    onCartUpdated: widget.onCartUpdated,
                    onGoToOrders: widget.onGoToOrders, 
                    onCheckout: () {  },
                  ),
                ),
              );
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: mockFoods.length,
        itemBuilder: (context, index) {
          final food = mockFoods[index];

          return FoodFeedCard(
            food: food,
            onAddToCart: () => _addToCart(food),
          );
        },
      ),
    );
  }
}
