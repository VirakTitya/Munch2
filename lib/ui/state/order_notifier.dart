import 'package:flutter/foundation.dart';

import '../../data/entities/order.dart';

class OrderNotifier extends ValueNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void addOrder(Order order) {
    value = [order, ...value];
    notifyListeners();
  }

  void clear() {
    value = [];
    notifyListeners();
  }
}

final orderNotifier = OrderNotifier();
