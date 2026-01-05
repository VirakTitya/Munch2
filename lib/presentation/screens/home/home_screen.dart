import 'package:flutter/material.dart';
// import 'package:munch2/domain/usecases/add_item_to_cart.dart';
import '../../widgets/food_feed_card.dart';
import '../../mock/mock_food.dart';
import '../../state/cart_notifier.dart';
import '../../../domain/entities/cart_item.dart';
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
            onAddToCart: () {
              // Add one unit of this food to the global cart
              cartNotifier.addItem(CartItem(item: food, quantity: 1));

              // show floating SnackBar with action to view cart
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
            },
          );
        },
      ),
    );
  }
}
