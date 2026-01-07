import 'package:flutter/foundation.dart';

import '../../data/entities/cart.dart';
import '../../data/entities/cart_item.dart';

class CartNotifier extends ValueNotifier<Cart> {
  CartNotifier() : super(Cart.empty());

  void addItem(CartItem item) {
    value = value.addItem(item);
    notifyListeners();
  }

  void clear() {
    value = value.clear();
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    value = value.updateQuantity(itemId, quantity);
    notifyListeners();
  }

  void removeItemById(String itemId) {
    value = value.removeItemById(itemId);
    notifyListeners();
  }

  void increment(String itemId) {
    final idx = value.items.indexWhere((ci) => ci.item.id == itemId);
    if (idx < 0) return;
    final current = value.items[idx].quantity;
    updateQuantity(itemId, current + 1);
  }

  void decrement(String itemId) {
    final idx = value.items.indexWhere((ci) => ci.item.id == itemId);
    if (idx < 0) return;
    final current = value.items[idx].quantity;
    if (current <= 1) {
      removeItemById(itemId);
    } else {
      updateQuantity(itemId, current - 1);
    }
  }
}

final cartNotifier = CartNotifier();
