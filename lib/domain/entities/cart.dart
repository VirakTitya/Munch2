import 'cart_item.dart';
import 'food_item.dart';

class CartException implements Exception {
  final String message;
  CartException(this.message);

  @override
  String toString() => 'CartException: $message';
}

class Cart {
  final List<CartItem> items;

  Cart({
    required this.items,
  });

  factory Cart.empty() => Cart(items: []);

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  /// Returns a new Cart with [newItem] added (or merged if it already exists).
  /// Enforces that all items in the cart come from the same restaurant and
  /// that quantities are positive.
  Cart addItem(CartItem newItem) {
    if (newItem.quantity <= 0) {
      throw CartException('Quantity must be greater than zero');
    }

    final existing = List<CartItem>.from(items);

    if (existing.isNotEmpty) {
      final firstRestaurantId = existing.first.item.restaurant.id;
      if (firstRestaurantId != newItem.item.restaurant.id) {
        throw CartException('All items in the cart must be from the same restaurant');
      }
    }

    final idx = existing.indexWhere((ci) => ci.item.id == newItem.item.id);
    if (idx >= 0) {
      final current = existing[idx];
      existing[idx] = CartItem(item: current.item, quantity: current.quantity + newItem.quantity);
    } else {
      existing.add(newItem);
    }

    return Cart(items: existing);
  }

  /// Convenience to add by `FoodItem` and primitive quantity.
  Cart addFoodItem(FoodItem item, int quantity) => addItem(CartItem(item: item, quantity: quantity));

  /// Remove an item by its `FoodItem.id`. Returns a new Cart.
  Cart removeItemById(String itemId) {
    final remaining = items.where((ci) => ci.item.id != itemId).toList();
    return Cart(items: remaining);
  }

  /// Update quantity for an item. If `quantity` <= 0 the item is removed.
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

  /// Total number of item units in the cart.
  int totalQuantity() => items.fold(0, (acc, ci) => acc + ci.quantity);

  /// Total price computed from `FoodItem.price * quantity` for each item.
  double totalPrice() => items.fold(0.0, (acc, ci) => acc + ci.item.price * ci.quantity);

  /// Empties the cart.
  Cart clear() => Cart.empty();
}
