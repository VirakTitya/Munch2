import 'package:flutter/material.dart';
import 'package:munch2/domain/model/order.dart';
import 'package:munch2/domain/service/order_service.dart';
import 'package:munch2/ui/widgets/order_cart.dart'; 

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

    final combined = [...widget.orderService.orderHistory, ...orderManager.orders];

    final Map<String, Order> byId = {};
    for (var o in combined) {
      byId[o.id] = o;
    }
    final List<Order> orders = byId.values.toList();

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
                return OrderCard(order: order); 
              },
            ),
    );
  }
}