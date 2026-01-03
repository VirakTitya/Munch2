import '../entities/cart.dart';
import '../entities/order.dart';
import '../repositories/order_repo.dart';

/// Use case to place an order from a cart. Delegates to [OrderRepository].
class CheckoutOrder {
	final OrderRepository repository;

	CheckoutOrder(this.repository);

	Future<Order> call(Cart cart) async {
		if (cart.isEmpty) {
			throw ArgumentError('Cannot checkout with an empty cart');
		}
		return repository.placeOrder(cart);
	}
}

