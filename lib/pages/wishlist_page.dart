import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../state/cart_state.dart';
import '../state/wishlist_state.dart';
import 'product_details.dart';

class WishlistPage extends StatefulWidget {
  final VoidCallback? onChanged;
  const WishlistPage({super.key, this.onChanged});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  void _refresh() {
    setState(() {});
    widget.onChanged?.call();
  }

  void _removeFromWishlist(Product product) {
    WishlistLogic.toggle(product);
    _refresh();
  }

  void _moveToCart(Product product) {
    CartLogic.addToCart(product);
    WishlistLogic.toggle(product);
    _refresh();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} moved to cart!"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        title: const Text("My Wishlist", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          if (globalWishlist.isNotEmpty)
            TextButton(
              onPressed: () {
                for (final p in [...globalWishlist]) {
                  CartLogic.addToCart(p);
                }
                globalWishlist.clear();
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All items moved to cart!"), behavior: SnackBarBehavior.floating),
                );
              },
              child: const Text("Add All to Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: globalWishlist.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("Your wishlist is emptys", style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text("Save items you love here", style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: globalWishlist.length,
        itemBuilder: (context, index) {
          final product = globalWishlist[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
            ),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product, onAddToCart: _refresh)),
              ).then((_) => _refresh()),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(product.image, width: 80, height: 80, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(product.category, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text("₹${product.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(4)),
                                child: Row(children: [
                                  Text(product.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  const Icon(Icons.star, size: 10, color: Colors.white),
                                ]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2874F0),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      elevation: 0,
                                    ),
                                    onPressed: () => _moveToCart(product),
                                    child: const Text("Move to Cart", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _removeFromWishlist(product),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                                  child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
