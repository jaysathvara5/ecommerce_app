import '../models/product_model.dart';

List<Product> globalWishlist = [];

class WishlistLogic {
  static bool isWishlisted(String productId) {
    return globalWishlist.any((p) => p.id == productId);
  }

  static void toggle(Product product) {
    if (isWishlisted(product.id)) {
      globalWishlist.removeWhere((p) => p.id == product.id);
    } else {
      globalWishlist.add(product);
    }
  }
}
