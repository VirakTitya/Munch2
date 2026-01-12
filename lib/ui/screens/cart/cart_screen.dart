import 'package:flutter/material.dart';
import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/model/cart_item.dart';
import 'package:munch2/domain/service/order_service.dart';
import 'package:munch2/ui/screens/order/order_screen.dart';
import 'package:munch2/ui/widgets/location_card.dart';
import 'package:munch2/ui/widgets/location_sheet.dart';
import '../../widgets/cart_item_card.dart';
import 'package:munch2/data/repository/mock_location.dart'; 

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

  String deliveryLocation = mockLocations[0].value;

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

  // Checkout process
  void _checkout() {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
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
      const SnackBar(content: Text('Order placed successfully!')),
    );
  }

  void _increaseItem(CartItem item) {
    orderService.increase(cart, item.food);
    setState(() {});
    widget.onCartUpdated?.call(cart);
  }

  void _decreaseItem(CartItem item) {
    orderService.decrease(cart, item.food);
    setState(() {});
    widget.onCartUpdated?.call(cart);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.totalPrice;
    final deliveryFee = 2.0; 
    final total = subtotal + deliveryFee;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty!'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return CartItemCard(
                        cartItem: cartItem,
                        onIncrease: () => _increaseItem(cartItem),
                        onDecrease: () => _decreaseItem(cartItem),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LocationCard(
                  address: deliveryLocation,
                  onEdit: () async {
                    final selected = await LocationPickerSheet.show(context);
                    if (selected != null) {
                      setState(() {
                        deliveryLocation = selected; 
                      });
                    }
                  },
                ),
                _priceRow('Subtotal', subtotal),
                _priceRow('Delivery', deliveryFee),
                const Divider(),
                _priceRow('Total', total, bold: true),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: _checkout,
                    child: const Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white),
                    ),
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
