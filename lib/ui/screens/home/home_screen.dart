import 'package:flutter/material.dart';
import 'package:munch2/model/cart.dart';
import 'package:munch2/model/cart_item.dart';
import 'package:munch2/data/mock/mock_food.dart';
import '../../widgets/food_feed_card.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final Cart cart;
  final ValueChanged<Cart>? onCartUpdated;
  final VoidCallback? onGoToOrders;

  const HomeScreen({super.key, required this.cart, this.onCartUpdated, this.onGoToOrders});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Cart cart; // local copy to keep UI snappy; synced with widget.cart

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
            onAddToCart: () async {
              final existing = cart.items;
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

                setState(() {
                  cart = cart.clear(); // Clear the cart
                });
                widget.onCartUpdated?.call(cart);
              }

              try {
                setState(() {
                  cart = cart.addItem(CartItem(item: food, quantity: 1)); // Add item to the cart
                });
                widget.onCartUpdated?.call(cart);

                final snack = SnackBar(
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
                          builder: (_) => CartScreen(cart: cart, onCartUpdated: widget.onCartUpdated, onGoToOrders: widget.onGoToOrders), // Pass the cart, callbacks to the CartScreen
                        ),
                      );
                    },
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snack);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          );
        },
      ),
    );
  }
}