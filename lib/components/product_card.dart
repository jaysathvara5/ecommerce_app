import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../state/wishlist_state.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback? onWishlistChanged;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
    this.onWishlistChanged,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool get _isWishlisted => WishlistLogic.isWishlisted(widget.product.id);

  void _toggleWishlist() {
    setState(() => WishlistLogic.toggle(widget.product));
    widget.onWishlistChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final discountPercent = ((widget.product.price * 0.2)).toStringAsFixed(0);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    widget.product.image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 140, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(4)),
                    child: Text("$discountPercent% OFF", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _toggleWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                      child: Icon(_isWishlisted ? Icons.favorite : Icons.favorite_border, size: 18, color: _isWishlisted ? Colors.red : Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Text(widget.product.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 2),
                            const Icon(Icons.star, size: 10, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("(${widget.product.ratingCount})", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("₹${widget.product.price.toStringAsFixed(0)}", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2874F0),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    elevation: 0,
                  ),
                  onPressed: widget.onAdd,
                  child: const Text("Add to Cart", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
