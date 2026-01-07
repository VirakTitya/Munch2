import 'package:flutter/material.dart';
import 'package:munch2/model/cart.dart';
import 'package:munch2/model/order.dart';
import '../../widgets/cart_item_card.dart';
import 'package:munch2/model/enum/order_status.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;
  final ValueChanged<Cart>? onCartUpdated;
  final VoidCallback? onGoToOrders;

  const CartScreen({super.key, required this.cart, this.onCartUpdated, this.onGoToOrders});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Cart cart;
  String deliveryLine1 = '123 Main Street, Apt 4B';
  String deliveryLine2 = 'New York, NY 10001';

  @override
  void initState() {
    super.initState();
    cart = widget.cart; // Initialize the cart from the passed argument
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cart != oldWidget.cart) {
      setState(() {
        cart = widget.cart;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Your Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🧾 Cart items
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return CartItemCard(
                        cart: cart,
                        cartItem: cartItem,
                        onCartUpdated: (updatedCart) {
                          setState(() {
                            cart = updatedCart; // Update the cart state
                          });
                          widget.onCartUpdated?.call(updatedCart);
                        },
                      );
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(deliveryLine1, style: const TextStyle(color: Colors.black54)),
                            Text(deliveryLine2, style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _showLocationPicker,
                        child: const Text('Change', style: TextStyle(color: Colors.orange)),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('\$${cart.totalPrice().toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Delivery'),
                    Text('\$2.00'),
                  ],
                ),
                const Divider(height: 20, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '\$${(cart.totalPrice() + 2.0).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Checkout button full width
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (cart.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty')));
                        return;
                      }

                      // Create an order and add to manager
                      final order = Order(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        items: cart.items,
                        totalPrice: cart.totalPrice(),
                        status: OrderStatus.pending,
                      );
                      orderManager.addOrder(order);

                      // If this CartScreen was pushed, pop it so the main scaffold is visible
                      if (Navigator.canPop(context)) Navigator.of(context).pop();

                      widget.onCartUpdated?.call(cart.clear());
                      widget.onGoToOrders?.call();

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed')));
                    },
                    child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Select Delivery Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.my_location, color: Colors.green),
                  ),
                  title: const Text('Use Current Location'),
                  subtitle: const Text("We'll detect your location automatically"),
                  onTap: () {
                    setState(() {
                      deliveryLine1 = 'Use Current Location';
                      deliveryLine2 = "We'll detect your location automatically";
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.home, color: Colors.green),
                  ),
                  title: const Text('Home'),
                  subtitle: const Text('Toul Kork, Phnom Penh'),
                  onTap: () {
                    setState(() {
                      deliveryLine1 = 'Home';
                      deliveryLine2 = 'Toul Kork, Phnom Penh';
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.work, color: Colors.orange),
                  ),
                  title: const Text('Office'),
                  subtitle: const Text('Bellevue, WA'),
                  onTap: () {
                    setState(() {
                      deliveryLine1 = 'Office';
                      deliveryLine2 = 'Bellevue, WA';
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}