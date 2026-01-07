import 'package:flutter/material.dart';
import 'package:munch2/model/cart.dart';
import 'package:munch2/ui/screens/order/order_screen.dart';


// screens
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Cart cart = Cart.empty(); // Initialize an empty cart

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        cart: cart,
        onCartUpdated: (updated) => setState(() => cart = updated),
      ),
      SearchScreen(cart: cart, onCartUpdated: (updated) => setState(() => cart = updated)),
      CartScreen(cart: cart, onCartUpdated: (updated) => setState(() => cart = updated)), // Pass the cart to CartScreen
      const OrdersScreen(),
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}