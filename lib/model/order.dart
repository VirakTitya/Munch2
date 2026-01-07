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
