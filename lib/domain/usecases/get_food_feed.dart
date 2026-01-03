import '../repositories/food_repo.dart';
import '../entities/food_item.dart';

class GetFoodFeed {
	final FoodRepository repository;

	GetFoodFeed(this.repository);

	Future<List<FoodItem>> call() => repository.getFoodFeed();
}

