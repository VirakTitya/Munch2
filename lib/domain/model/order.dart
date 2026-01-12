import 'cart.dart';
import 'cart_item.dart';
import 'package:munch2/ui/screens/cart/app_string.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime orderTime;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.orderTime,
  });

  factory Order.fromCart(Cart cart) {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: cart.items
          .map((e) => CartItem(food: e.food, quantity: e.quantity))
          .toList(),
      total: cart.totalPrice + AppStrings.deliveryFee,
      orderTime: DateTime.now(),
    );
  }
}
