import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/model/restaurant.dart';

class RestaurantRepository {
  /// Fetch all restaurants from JSON
  Future<List<Restaurant>> getRestaurants() async {
    final jsonString = await rootBundle.loadString('assets/restaurants.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) {
      return Restaurant(
        id: json['id'],
        name: json['name'],
        logoUrl: json['logoUrl'],
        location: json['location'],
        rating: (json['rating'] as num).toDouble(),
        deliveryTime: json['deliveryTime'],
      );
    }).toList();
  }
}
