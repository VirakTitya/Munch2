import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/model/food_item.dart';
import '../../domain/model/restaurant.dart';

class FoodRepository {
  /// Load all foods from JSON
  Future<List<FoodItem>> getFoods() async {
    final jsonString = await rootBundle.loadString('assets/foods.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) {
      final restaurantJson = json['restaurant'];
      final restaurant = Restaurant(
        id: restaurantJson['id'],
        name: restaurantJson['name'],
        logoUrl: restaurantJson['logoUrl'],
        location: restaurantJson['location'],
        rating: (restaurantJson['rating'] as num).toDouble(),
        deliveryTime: restaurantJson['deliveryTime'],
      );

      return FoodItem(
        id: json['id'],
        name: json['name'],
        price: (json['price'] as num).toDouble(),
        description: json['description'],
        imageUrl: json['imageUrl'],
        restaurant: restaurant,
      );
    }).toList();
  }

  /// Filter foods by restaurant
  List<FoodItem> getFoodsByRestaurant(List<FoodItem> foods, Restaurant restaurant) {
    return foods.where((f) => f.restaurant.id == restaurant.id).toList();
  }
}
