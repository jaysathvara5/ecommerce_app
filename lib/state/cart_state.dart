import '../models/product_model.dart';

List<Product> globalCart = [];

class CartLogic {
  // Static method taaki bina object banaye call ho sake
  static void addToCart(Product product) {
    int index = globalCart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      globalCart[index].quantity++;
    } else {
      globalCart.add(product);
    }
  }

  static double calculateTotal() {
    return globalCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}