import 'package:flutter/material.dart';
import '../../widgets/food_feed_card.dart';
import '../../mock/mock_food.dart';
import '../../widgets/bottom_nav.dart';

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
              // UI ONLY – logic comes later
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
