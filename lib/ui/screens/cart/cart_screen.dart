import 'package:flutter/material.dart';

// widgets
import '../../widgets/cart_item_card.dart';
import '../../state/cart_notifier.dart';
import '../../state/order_notifier.dart';
import '../../../data/entities/order.dart';
import '../../../data/enum/order_status.dart';
import '../order/order_screen.dart';

// Selected delivery address (shared for this screen)
final ValueNotifier<String> deliveryAddressNotifier = ValueNotifier(
  '123 Main Street, Apt 4B\nNew York, NY 10001',
);

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
              },
            ),
          ),

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
                    // Show delivery address card only when cart has items
                    if (cart.isNotEmpty) ...[
                      ValueListenableBuilder<String>(
                        valueListenable: deliveryAddressNotifier,
                        builder: (context, address, _) {
                          return _DeliveryAddressCard(
                            address: address,
                            onChange: () async {
                              final result = await _showLocationPicker(context);
                              if (result != null) {
                                deliveryAddressNotifier.value = result;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Location set: $result')),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

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
                          final cartValue = cart as dynamic;
                          if (cartValue.isEmpty) return;

                          final newOrder = Order(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            items: List.from(cartValue.items),
                            totalPrice: cartValue.totalPrice(),
                            status: OrderStatus.pending,
                          );

                          orderNotifier.addOrder(newOrder);
                          cartNotifier.clear();

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const OrdersScreen()),
                          );
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
          ),
        ],
      ),
    );
  }

  Future<String?> _showLocationPicker(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Delivery Location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.my_location, color: Colors.green),
                title: const Text('Use Current Location'),
                subtitle: const Text("We'll detect your location automatically"),
                onTap: () => Navigator.of(context).pop('Use Current Location - Detected'),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.green),
                title: const Text('Home'),
                subtitle: const Text('Toul Kork, Phnom Penh'),
                onTap: () => Navigator.of(context).pop('Home • Toul Kork, Phnom Penh'),
              ),
              ListTile(
                leading: const Icon(Icons.work, color: Colors.orange),
                title: const Text('Office'),
                subtitle: const Text('Bellevue, WA'),
                onTap: () => Navigator.of(context).pop('Office • Bellevue, WA'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
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

class _DeliveryAddressCard extends StatelessWidget {
  final String address;
  final VoidCallback onChange;

  const _DeliveryAddressCard({required this.address, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: const Icon(Icons.location_on, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            child: const Text('Change', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}

