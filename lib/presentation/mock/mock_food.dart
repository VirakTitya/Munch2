import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';

final mockRestaurant = Restaurant(
  id: 'r1',
  name: 'Burger House',
  rating: 4.5,
  logoUrl: '',
);

final mockFoods = [
  FoodItem(
    id: 'f1',
    name: 'Cheese Burger',
    price: 5.99,
    imageUrl:
        'https://images.unsplash.com/photo-1550547660-d9450f859349',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f2',
    name: 'Chicken Pizza',
    price: 8.49,
    imageUrl:
        'https://images.unsplash.com/photo-1601924582975-7e1a9f0a8d6a',
    restaurant: mockRestaurant,
  ),
];
