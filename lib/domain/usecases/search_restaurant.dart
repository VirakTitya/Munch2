import '../repositories/food_repo.dart';
import '../entities/restaurant.dart';

class SearchRestaurant {
	final FoodRepository repository;

	SearchRestaurant(this.repository);

	Future<List<Restaurant>> call(String query) => repository.searchRestaurants(query);
}

