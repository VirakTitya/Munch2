import 'package:flutter/material.dart';
import 'package:munch2/domain/model/order.dart';
import 'package:munch2/domain/service/order_service.dart';
import 'package:munch2/ui/widgets/order_cart.dart'; // Make sure this widget can display an Order

class OrdersScreen extends StatefulWidget {
  final OrderService orderService;

  const OrdersScreen({super.key, required this.orderService});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Order> orders = widget.orderService.orderHistory;

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
                final order = orders[index];
                return OrderCard(order: order); // Pass Order directly
              },
            ),
    );
  }
}
