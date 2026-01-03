import 'package:flutter_test/flutter_test.dart';

import 'package:munch2/domain/entities/cart.dart';
import 'package:munch2/domain/entities/cart_item.dart';
import 'package:munch2/domain/entities/food_item.dart';
import 'package:munch2/domain/entities/restaurant.dart';
import 'package:munch2/domain/usecases/add_item_to_cart.dart';
import 'package:munch2/domain/usecases/checkout_order.dart';
import 'package:munch2/domain/repositories/order_repo.dart';
import 'package:munch2/domain/entities/order.dart';
import 'package:munch2/domain/enum/order_status.dart';

class _MockOrderRepository implements OrderRepository {
  @override
  Future<Order> placeOrder(Cart cart) async {
    return Order(
      id: 'o1',
      items: cart.items,
      totalPrice: cart.totalPrice(),
      status: OrderStatus.pending,
    );
  }

  @override
  Future<List<Order>> getOrders() async => [];
}

void main() {
  final restaurant = Restaurant(id: 'r1', name: 'R', logoUrl: '', rating: 4.5);
  final foodA = FoodItem(id: 'f1', name: 'A', price: 5.0, imageUrl: '', restaurant: restaurant);

  test('AddItemToCart adds item to empty cart', () {
    final cart = Cart.empty();
    final item = CartItem(item: foodA, quantity: 1);
    final usecase = AddItemToCart();
    final updated = usecase(cart, item);

    expect(updated.items.length, 1);
    expect(updated.totalQuantity(), 1);
  });

  test('CheckoutOrder delegates to repository and returns created order', () async {
    final cart = Cart.empty().addFoodItem(foodA, 2);
    final repo = _MockOrderRepository();
    final usecase = CheckoutOrder(repo);

    final order = await usecase(cart);

    expect(order.totalPrice, cart.totalPrice());
    expect(order.items.length, cart.items.length);
    expect(order.status, OrderStatus.pending);
  });
}
