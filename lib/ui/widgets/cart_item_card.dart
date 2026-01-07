import 'package:flutter/material.dart';
import 'package:munch2/model/cart.dart';
import 'package:munch2/model/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(Cart) onCartUpdated; // Callback to notify parent about cart updates
  final Cart cart; // Pass the current cart to allow updates

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onCartUpdated,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                cartItem.item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.orange.shade100,
                  child: const Icon(Icons.fastfood),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  // Decrement the item quantity
                  final updatedCart = cart.decrement(cartItem.item.id);
                  onCartUpdated(updatedCart); // Notify parent about the updated cart
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('${cartItem.quantity}'),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  // Increment the item quantity
                  final updatedCart = cart.increment(cartItem.item.id);
                  onCartUpdated(updatedCart); // Notify parent about the updated cart
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}