import 'package:munch2/ui/screens/cart/app_string.dart';
import 'cart_item.dart';
import 'cart.dart';

/// Represents a single order
class Order {
  final String id;
  final List<CartItem> items; // snapshot of cart items at checkout
  final double total; // total including delivery fee
  final DateTime orderTime;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.orderTime,
  });

  /// Factory constructor to create an Order directly from a Cart
  factory Order.fromCart(Cart cart) {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // unique ID
      items: cart.items.map((e) => e.copy()).toList(), // snapshot of items
      total: cart.totalPrice + AppStrings.deliveryFee, // include delivery
      orderTime: DateTime.now(),
    );
  }
}

/// Manages all orders globally
class OrderManager {
  final List<Order> _orders = [];

  /// Returns all orders (read-only)
  List<Order> get orders => List.unmodifiable(_orders);

  /// Add a new order
  void addOrder(Order order) {
    _orders.add(order);
  }
}

/// Global singleton instance to access orders from anywhere
final orderManager = OrderManager();
