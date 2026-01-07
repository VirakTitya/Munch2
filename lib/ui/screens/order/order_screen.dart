import 'package:flutter/material.dart';
import 'package:munch2/model/order.dart';
import 'package:munch2/ui/widgets/order_cart.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    orderManager.addListener(_onOrdersChanged);
  }

  @override
  void dispose() {
    orderManager.removeListener(_onOrdersChanged);
    super.dispose();
  }

  void _onOrdersChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final List<Order> orders = orderManager.orders;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orders[index]); // Pass non-nullable Order
              },
            ),
    );
  }
}