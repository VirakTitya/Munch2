import 'package:munch2/domain/model/food_item.dart';
import 'mock_restaurant.dart';

final mockFoods = <FoodItem>[
  // 10 items for first restaurant (mockRestaurants[0])
  FoodItem(
    id: 'b1',
    name: 'Classic Burger',
    price: 6.99,
    imageUrl: 'https://thumbs.dreamstime.com/b/home-made-tasty-burger-meat-cutlet-cheese-wooden-vintage-table-vertical-image-copy-space-133427623.jpg',
    restaurant: mockRestaurants[0], description: 'kdmv',
  ),
  FoodItem(
    id: 'b2',
    name: 'Cheese Burger',
    price: 7.49,
    imageUrl: 'https://thumbs.dreamstime.com/b/vertical-image-appetizing-multilayer-hamburger-dark-background-vertical-image-appetizing-multilayer-hamburger-278445226.jpg',
    restaurant: mockRestaurants[0], description: 'hello',
  ),
  

  // 10 items for second restaurant (mockRestaurants[1])
  FoodItem(
    id: 'p1',
    name: 'Margherita Pizza',
    price: 7.99,
    imageUrl: 'https://media.istockphoto.com/id/451866291/photo/margherita-pizza.jpg?s=612x612&w=0&k=20&c=9GdIWikoDItvvOlT5djjTPOJHj1s9JFgomcFzA9uKBU=',
    restaurant: mockRestaurants[1], description: 'jmr',
  ),
  FoodItem(
    id: 'p2',
    name: 'Pepperoni Pizza',
    price: 8.99,
    imageUrl: 'https://www.shutterstock.com/shutterstock/photos/225747550/display_1500/stock-photo-hot-homemade-pepperoni-pizza-ready-to-eat-225747550.jpg',
    restaurant: mockRestaurants[1], description: 'jmr',
  ),
];