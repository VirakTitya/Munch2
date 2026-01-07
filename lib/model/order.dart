import 'enum/order_status.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
  });
}

class OrderManager {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders); // Expose orders as an unmodifiable list

  void addOrder(Order order) {
    _orders.insert(0, order); // Add the new order to the beginning of the list
  }

  void clear() {
    _orders.clear(); // Clear all orders
  }
}

final orderManager = OrderManager();