import '../model/cart.dart';
import '../model/cart_item.dart';
import '../model/food_item.dart';
import '../model/order.dart';

class OrderService {

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addItem(Cart cart, FoodItem food) {
    final item = _findItem(cart, food);
    if (item != null) {
      item.quantity++;
    } else {
      cart.items.add(CartItem(food: food, quantity: 1));
    }
  }

  void increase(Cart cart, FoodItem food) {
    final item = _findItem(cart, food);
    if (item != null) item.quantity++;
  }

  void decrease(Cart cart, FoodItem food) {
    final item = _findItem(cart, food);
    if (item == null) return;

    item.quantity--;
    if (item.quantity <= 0) {
      cart.items.remove(item);
    }
  }

  CartItem? _findItem(Cart cart, FoodItem food) {
    try {
      return cart.items.firstWhere((item) => item.food.id == food.id);
    } catch (_) {
      return null;
    }
  }

  Order checkout(Cart cart) {
    if (cart.items.isEmpty) {
      throw Exception('Cart is empty');
    }

    final order = Order.fromCart(cart);
    _orders.add(order);       
    cart.items.clear();      

    return order;
  }

  void clearOrders() {
    _orders.clear();
  }

  void clearCart(Cart cart) {
    cart.items.clear();
  }
}
