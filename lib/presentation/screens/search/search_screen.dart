import 'package:flutter/material.dart';
import 'package:munch2/presentation/mock/mock_restaurant.dart';
import '../../widgets/restaurant_card.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';
  String selectedCategory = 'Trending';

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = mockRestaurants.where((r) {
      return r.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Search',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) {
                  setState(() => searchText = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for restaurants or dishes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.orange.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['Trending', 'Burger', 'Pizza']
                    .map((category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (_) {
                              setState(() => selectedCategory = category);
                            },
                            selectedColor: Colors.orange,
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Restaurant list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: filteredRestaurants
                    .map((r) => RestaurantCard(restaurant: r))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
