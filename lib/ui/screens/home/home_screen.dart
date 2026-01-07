import 'package:flutter/material.dart';
// import 'package:munch2/domain/usecases/add_item_to_cart.dart';
import '../../widgets/food_feed_card.dart';
import '../../../data/mock/mock_food.dart';
import '../../state/cart_notifier.dart';
import '../../../data/entities/cart_item.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                        MaterialPageRoute(builder: (_) => const CartScreen()),
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
