import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../state/cart_state.dart';
import '../state/wishlist_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool get _isWishlisted => WishlistLogic.isWishlisted(widget.product.id);

  void _toggleWishlist() {
    setState(() => WishlistLogic.toggle(widget.product));
    widget.onAddToCart();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(product.category, style: const TextStyle(color: Colors.white, fontSize: 14)),
        actions: [
          IconButton(
            icon: Icon(_isWishlisted ? Icons.favorite : Icons.favorite_border, color: _isWishlisted ? Colors.red.shade300 : Colors.white),
            onPressed: _toggleWishlist,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Image.network(
                        product.image,
                        height: 260,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Text(product.category, style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 8),
                        Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(4)),
                              child: Row(children: [
                                Text(product.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 3),
                                const Icon(Icons.star, size: 14, color: Colors.white),
                              ]),
                            ),
                            const SizedBox(width: 8),
                            Text("${product.ratingCount} ratings", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("₹${product.price.toStringAsFixed(0)}", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(width: 10),
                            Text(
                              "₹${(product.price * 1.2).toStringAsFixed(0)}",
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade400, decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: 8),
                            Text("20% off", style: TextStyle(fontSize: 14, color: Colors.green.shade600, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("Inclusive of all taxes", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text("Description", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(product.desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2874F0),
                      side: const BorderSide(color: Color(0xFF2874F0)),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    onPressed: _toggleWishlist,
                    icon: Icon(_isWishlisted ? Icons.favorite : Icons.favorite_border, size: 18),
                    label: Text(_isWishlisted ? "Wishlisted" : "Wishlist"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2874F0),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      CartLogic.addToCart(product);
                      widget.onAddToCart();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${product.name} added to cart!"),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: const Text("Add to Cart", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
