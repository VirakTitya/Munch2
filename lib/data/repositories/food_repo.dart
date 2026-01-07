import 'package:munch2/model/food_item.dart';
import 'package:munch2/model/restaurant.dart';


abstract class FoodRepository {
  Future<List<FoodItem>> getFoodFeed();
  Future<List<Restaurant>> searchRestaurants(String query);
}
