import '../entities/food_item.dart';
import '../entities/restaurant.dart';

abstract class FoodRepository {
  Future<List<FoodItem>> getFoodFeed();
  Future<List<Restaurant>> searchRestaurants(String query);
}
