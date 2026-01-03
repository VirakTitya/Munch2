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
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f2',
    name: 'Chicken Pizza',
    price: 8.49,
    imageUrl: 'https://images.unsplash.com/photo-1601924582975-7e1a9f0a8d6a',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f3',
    name: 'Veggie Salad',
    price: 4.75,
    imageUrl: 'https://images.unsplash.com/photo-1551218808-94e220e084d2',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f4',
    name: 'Fish Tacos',
    price: 7.25,
    imageUrl: 'https://images.unsplash.com/photo-1514512364185-3d6cc0e1b1a3',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f5',
    name: 'Sushi Roll',
    price: 10.50,
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f6',
    name: 'Pasta Carbonara',
    price: 9.00,
    imageUrl: 'https://images.unsplash.com/photo-1523986371872-9d3ba2e2f642',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f7',
    name: 'Steak Sandwich',
    price: 11.99,
    imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f8',
    name: 'Caesar Salad',
    price: 6.25,
    imageUrl: 'https://images.unsplash.com/photo-1542444459-db5f0f3a0a2f',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f9',
    name: 'Chocolate Cake',
    price: 3.99,
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947',
    restaurant: mockRestaurant,
  ),
  FoodItem(
    id: 'f10',
    name: 'Mango Smoothie',
    price: 2.99,
    imageUrl: 'https://images.unsplash.com/photo-1542444459-0c9b1f8a9f8f',
    restaurant: mockRestaurant,
  ),
];
