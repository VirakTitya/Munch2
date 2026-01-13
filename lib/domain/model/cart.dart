import 'package:munch2/domain/model/cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.subtotal);
  static Cart empty() {
    return Cart(items: []);
  }
}
