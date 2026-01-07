import 'package:munch2/model/cart.dart';
import 'package:munch2/model/order.dart';


abstract class OrderRepository {
  Future<Order> placeOrder(Cart cart);
  Future<List<Order>> getOrders();
}
