import 'package:flutter/material.dart';
import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/service/order_service.dart';

// Screens
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';
import '../order/order_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  Cart cart = Cart.empty();
  final OrderService orderService = OrderService(); // Track orders

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        cart: cart,
        onCartUpdated: (updatedCart) => setState(() => cart = updatedCart),
        onGoToOrders: () => setState(() => _currentIndex = 3),
      ),
      SearchScreen(
        cart: cart,
        onCartUpdated: (updatedCart) => setState(() => cart = updatedCart),
      ),
      CartScreen(
        cart: cart,
        onCartUpdated: (updatedCart) => setState(() => cart = updatedCart),
        onGoToOrders: () => setState(() => _currentIndex = 3),
        onCheckout: () {
          if (cart.items.isEmpty) return;

          final order = orderService.checkout(cart);
          setState(() {
            cart = Cart.empty(); // Cart is cleared after checkout
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order ${order.id} placed! Total: \$${order.total.toStringAsFixed(2)}')),
          );
        },
      ),
      OrdersScreen(orderService: orderService), // Pass service to OrdersScreen
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
        ],
      ),
    );
  }
}
