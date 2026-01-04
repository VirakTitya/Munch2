import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:munch2/domain/usecases/add_item_to_cart.dart';
import '../../widgets/food_feed_card.dart';
import '../../mock/mock_food.dart';
=======
// import 'package:munch2/domain/usecases/add_item_to_cart.dart';
import '../../widgets/food_feed_card.dart';
import '../../mock/mock_food.dart';
import '../../state/cart_notifier.dart';
import '../../../domain/entities/cart_item.dart';
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df

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
            },
          );
        },
      ),
    );
  }
}
