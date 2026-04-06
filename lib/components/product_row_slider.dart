import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../state/cart_state.dart';
import '../state/wishlist_state.dart';
import 'product_card.dart';

class ProductRowSlider extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final VoidCallback onCartChanged;

  const ProductRowSlider({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onCartChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ProductCard(
                product: product,
                onTap: () => onProductTap(product),
                onAdd: () {
                  CartLogic.addToCart(product);
                  onCartChanged();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.name} added to cart!"),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onWishlistChanged: onCartChanged,
              ),
            ),
          );
        },
      ),
    );
  }
}
