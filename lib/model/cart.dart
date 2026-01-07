import 'cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  factory Cart.empty() => Cart(items: []);

  Cart addItem(CartItem item) {
    final existing = List<CartItem>.from(items);
    final idx = existing.indexWhere((ci) => ci.item.id == item.item.id);
    if (idx >= 0) {
      final current = existing[idx];
      existing[idx] = CartItem(item: current.item, quantity: current.quantity + item.quantity);
    } else {
      existing.add(item);
    }
    return Cart(items: existing);
  }

  Cart clear() {
    return Cart.empty();
  }

  Cart updateQuantity(String itemId, int quantity) {
    final existing = List<CartItem>.from(items);
    final idx = existing.indexWhere((ci) => ci.item.id == itemId);
    if (idx < 0) return this;

    if (quantity <= 0) {
      existing.removeAt(idx);
    } else {
      final current = existing[idx];
      existing[idx] = CartItem(item: current.item, quantity: quantity);
    }

    return Cart(items: existing);
  }

  Cart removeItemById(String itemId) {
    final remaining = items.where((ci) => ci.item.id != itemId).toList();
    return Cart(items: remaining);
  }

  Cart increment(String itemId) {
    final idx = items.indexWhere((ci) => ci.item.id == itemId);
    if (idx < 0) return this;

    final current = items[idx];
    return updateQuantity(itemId, current.quantity + 1);
  }

  Cart decrement(String itemId) {
    final idx = items.indexWhere((ci) => ci.item.id == itemId);
    if (idx < 0) return this;

    final current = items[idx];
    if (current.quantity <= 1) {
      return removeItemById(itemId);
    } else {
      return updateQuantity(itemId, current.quantity - 1);
    }
  }

  int totalQuantity() {
    return items.fold(0, (acc, ci) => acc + ci.quantity);
  }

  double totalPrice() {
    return items.fold(0.0, (acc, ci) => acc + ci.item.price * ci.quantity);
  }
}