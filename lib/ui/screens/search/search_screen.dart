import 'package:flutter/material.dart';
import 'package:munch2/data/repository/food_repository.dart';
import 'package:munch2/data/repository/restaurant_repository.dart';
import 'package:munch2/domain/model/cart.dart';
import 'package:munch2/domain/model/restaurant.dart';
import 'package:munch2/domain/service/order_service.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../../widgets/restaurant_card.dart';

class SearchScreen extends StatefulWidget {
  final Cart cart;
  final OrderService orderService;
  final FoodRepository foodRepository;
  final RestaurantRepository restaurantRepository;
  final ValueChanged<Cart>? onCartUpdated;

  const SearchScreen({
    super.key,
    required this.cart,
    required this.orderService,
    required this.foodRepository,
    required this.restaurantRepository,
    this.onCartUpdated,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';
  late Future<List<Restaurant>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = widget.restaurantRepository.getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Search',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for restaurants...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Restaurant>>(
                future: _restaurantsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No restaurants found'));
                  }

                  final filteredRestaurants = snapshot.data!
                      .where((r) =>
                          r.name.toLowerCase().contains(searchText.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                restaurant: restaurant,
                                cart: widget.cart,
                                orderService: widget.orderService,
                                foodRepository: widget.foodRepository,
                                onCartUpdated: widget.onCartUpdated,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
