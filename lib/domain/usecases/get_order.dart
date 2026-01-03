import '../entities/order.dart';
import '../repositories/order_repo.dart';

class GetOrders {
	final OrderRepository repository;

	GetOrders(this.repository);

	Future<List<Order>> call() => repository.getOrders();
}

