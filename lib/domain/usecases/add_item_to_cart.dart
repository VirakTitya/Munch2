import '../entities/cart.dart';
import '../entities/cart_item.dart';

/// Use case to add a `CartItem` into a `Cart`.
/// Delegates to `Cart.addItem` and returns the resulting new `Cart`.
class AddItemToCart {
	AddItemToCart();

	Cart call(Cart cart, CartItem item) {
		return cart.addItem(item);
	}
}
