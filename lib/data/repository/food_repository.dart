import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/model/food_item.dart';
import '../../domain/model/restaurant.dart';

class FoodRepository {
  /// Load all foods from JSON
  Future<List<FoodItem>> getFoods() async {
    try {
      final jsonString = await rootBundle.loadString('assets/foods.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      // Parse each item defensively to avoid Null type errors
      final List<FoodItem> items = [];
      for (var i = 0; i < jsonList.length; i++) {
        final entry = jsonList[i] as Map<String, dynamic>;

        final restaurantJson = (entry['restaurant'] ?? {}) as Map<String, dynamic>;

        final String rId = (restaurantJson['id'] ?? 'unknown').toString();
        final String rName = (restaurantJson['name'] ?? 'Unknown').toString();
        final String rLogo = (restaurantJson['logoUrl'] ?? '').toString();
        final String rLocation = (restaurantJson['location'] ?? '').toString();
        final double rRating = (restaurantJson['rating'] is num)
            ? (restaurantJson['rating'] as num).toDouble()
            : double.tryParse(restaurantJson['rating']?.toString() ?? '') ?? 0.0;

        final restaurant = Restaurant(
          id: rId,
          name: rName,
          logoUrl: rLogo,
          location: rLocation,
          rating: rRating,
        );

        final String id = (entry['id'] ?? '').toString();
        final String name = (entry['name'] ?? '').toString();
        final double price = (entry['price'] is num)
            ? (entry['price'] as num).toDouble()
            : double.tryParse(entry['price']?.toString() ?? '') ?? 0.0;
        final String description = (entry['description'] ?? '').toString();
        final String imageUrl = (entry['imageUrl'] ?? '').toString();

        items.add(FoodItem(
          id: id,
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl,
          restaurant: restaurant,
        ));
      }

      return items;
    } catch (e, st) {
      throw Exception('Failed to load assets/foods.json: $e\n$st');
    }
  }

  /// Filter foods by restaurant
  List<FoodItem> getFoodsByRestaurant(List<FoodItem> foods, Restaurant restaurant) {
    return foods.where((f) => f.restaurant.id == restaurant.id).toList();
  }
}
