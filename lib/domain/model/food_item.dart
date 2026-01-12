import 'restaurant.dart';

class FoodItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final Restaurant restaurant;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.restaurant, 
    required this.description,
  });
}
