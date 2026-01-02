import '../entities/cart.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Order> placeOrder(Cart cart);
  Future<List<Order>> getOrders();
}
