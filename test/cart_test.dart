import 'package:flutter_test/flutter_test.dart';

import 'package:munch2/domain/entities/cart.dart';
import 'package:munch2/domain/entities/food_item.dart';
import 'package:munch2/domain/entities/restaurant.dart';
import 'package:munch2/domain/entities/cart_item.dart';

void main() {
  final restaurant = Restaurant(id: 'r1', name: 'R', logoUrl: '', rating: 4.5);
  final foodA = FoodItem(id: 'f1', name: 'A', price: 5.0, imageUrl: '', restaurant: restaurant);
  final foodB = FoodItem(id: 'f2', name: 'B', price: 3.0, imageUrl: '', restaurant: restaurant);

  test('add item to empty cart', () {
    final cart = Cart.empty();
    final updated = cart.addFoodItem(foodA, 2);
    expect(updated.items.length, 1);
    expect(updated.totalQuantity(), 2);
  });

  test('merge quantities when adding same item', () {
    final cart = Cart(items: [CartItem(item: foodA, quantity: 1)]);
    final updated = cart.addFoodItem(foodA, 3);
    expect(updated.items.length, 1);
    expect(updated.totalQuantity(), 4);
  });

  test('total price calculation', () {
    final cart = Cart(items: [CartItem(item: foodA, quantity: 2), CartItem(item: foodB, quantity: 1)]);
    expect(cart.totalPrice(), 13.0);
  });
}
