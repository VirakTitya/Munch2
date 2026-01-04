import 'package:flutter/material.dart';

<<<<<<< HEAD
class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key});
=======
import '../../domain/entities/cart_item.dart';
import '../state/cart_notifier.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({super.key, required this.cartItem});
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df

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
<<<<<<< HEAD
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fastfood),
=======
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
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
<<<<<<< HEAD
              children: const [
                Text(
                  'Chicken Burger',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$6.50',
                  style: TextStyle(color: Colors.grey),
=======
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
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df
                ),
              ],
            ),
          ),

<<<<<<< HEAD
          // quantity (UI only)
          Row(
            children: const [
              Icon(Icons.remove_circle_outline),
              SizedBox(width: 8),
              Text('1'),
              SizedBox(width: 8),
              Icon(Icons.add_circle_outline),
=======
          // quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => cartNotifier.decrement(cartItem.item.id),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('${cartItem.quantity}'),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => cartNotifier.increment(cartItem.item.id),
              ),
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df
            ],
          ),
        ],
      ),
    );
  }
}
