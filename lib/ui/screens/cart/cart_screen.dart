import 'package:flutter/material.dart';
import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/service/order_service.dart';
import 'package:munch2/ui/screens/order/order_screen.dart';
import 'package:munch2/ui/screens/cart/app_string.dart';
import '../../widgets/cart_item_card.dart';


class CartScreen extends StatefulWidget {
  final Cart cart;
  final ValueChanged<Cart>? onCartUpdated;
  final VoidCallback? onGoToOrders;
  final VoidCallback? onCheckout;
  final OrderService orderService;

  const CartScreen({
    super.key,
    required this.cart,
    required this.orderService,
    this.onCartUpdated,
    this.onGoToOrders,
    this.onCheckout,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Cart cart;
  late OrderService orderService;

  @override
  void initState() {
    super.initState();
    cart = widget.cart;
    orderService = widget.orderService;
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cart != oldWidget.cart) {
      cart = widget.cart;
    }
  }

  void _checkout() {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.cartEmptySnack)),
      );
      return;
    }

      orderService.checkout(cart);

      widget.onCartUpdated?.call(cart);

      widget.onCheckout?.call();

      if (widget.onGoToOrders != null) {
        widget.onGoToOrders!.call();
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => OrdersScreen(orderService: orderService),
        ));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.orderPlaced)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.totalPrice;
    final total = subtotal + AppStrings.deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cartTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Cart items
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text(AppStrings.emptyCart))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return CartItemCard(
                        cartItem: cartItem,
                        onIncrease: () {
                          orderService.increase(cart, cartItem.food);
                          setState(() {}); // rebuild UI
                          widget.onCartUpdated?.call(cart);
                        },
                        onDecrease: () {
                          orderService.decrease(cart, cartItem.food);
                          setState(() {});
                          widget.onCartUpdated?.call(cart);
                        },
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _priceRow(AppStrings.subtotal, subtotal),
                _priceRow(AppStrings.delivery, AppStrings.deliveryFee),
                const Divider(),
                _priceRow(AppStrings.total, total, bold: true),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    child: const Text(AppStrings.checkout),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        Text('\$${value.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
      ],
    );
  }
}
