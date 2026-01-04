import 'package:flutter/material.dart';

// widgets
import '../../widgets/cart_item_card.dart';
<<<<<<< HEAD
=======
import '../../state/cart_notifier.dart';
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
<<<<<<< HEAD
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3, // mock items
              itemBuilder: (context, index) {
                return const CartItemCard();
=======
            child: ValueListenableBuilder(
              valueListenable: cartNotifier,
              builder: (context, value, _) {
                final cart = value as dynamic; // Cart
                if (cart.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return CartItemCard(cartItem: cart.items[index]);
                  },
                );
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df
              },
            ),
          ),

<<<<<<< HEAD
          // 💵 Summary + Checkout
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
              children: [
                _SummaryRow(label: 'Subtotal', value: '\$18.50'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Delivery', value: '\$2.00'),
                const Divider(height: 24),
                _SummaryRow(
                  label: 'Total',
                  value: '\$20.50',
                  isBold: true,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // later: go to CheckoutScreen
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
=======
          // 💵 Summary + Checkout (listens to cartNotifier so totals update)
          ValueListenableBuilder(
            valueListenable: cartNotifier,
            builder: (context, value, _) {
              final cart = value as dynamic;
              final subtotal = cart.totalPrice();
              final delivery = 2.0;
              final total = subtotal + delivery;

              return Container(
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
                  children: [
                    _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _SummaryRow(label: 'Delivery', value: '\$${delivery.toStringAsFixed(2)}'),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: '\$${total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // later: go to CheckoutScreen
                        },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

