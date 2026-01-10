import 'package:munch2/ui/screens/cart/app_string.dart';
import 'cart_item.dart';
import 'cart.dart';

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
      items: cart.items.map((e) => e.copy()).toList(), 
      total: cart.totalPrice + AppStrings.deliveryFee, 
      orderTime: DateTime.now(),
    );
  }
}

class OrderManager {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder(Order order) {
    _orders.add(order);
  }
}

final orderManager = OrderManager();
