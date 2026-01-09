import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/model/cart_item.dart';
import 'package:munch2/domain/model/food_item.dart';
import 'package:munch2/domain/model/order.dart';
import 'package:munch2/ui/screens/cart/app_string.dart';

class OrderService {
  final List<Order> orderHistory = [];

  void addItem(Cart cart, FoodItem food) {
    final item = _findItem(cart, food);
    if (item != null) {
      item.quantity++;
    } else {
      cart.items.add(CartItem(food: food));
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
    if (item.quantity <= 0) cart.items.remove(item);
  }

  CartItem? _findItem(Cart cart, FoodItem food) {
    try {
      return cart.items.firstWhere((item) => item.food.id == food.id);
    } catch (_) {
      return null;
    }
  }

  /// Clear all items in the cart
  void clearCart(Cart cart) {
    cart.items.clear();
  }

  /// Checkout: create order from cart and clear cart
  Order checkout(Cart cart) {
    if (cart.items.isEmpty) {
      throw Exception("Cart is empty");
    }

    // Make a snapshot for order
    final orderItems = cart.items
        .map((item) => CartItem(food: item.food, quantity: item.quantity))
        .toList();

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: orderItems,
      total: cart.totalPrice + AppStrings.deliveryFee,
      orderTime: DateTime.now(),
    );

    orderHistory.add(order);

    // Clear cart
    clearCart(cart);

    return order;
  }
}
