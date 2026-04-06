import 'package:flutter/material.dart';
import '../state/cart_state.dart';
import 'checkout_page.dart'; 

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        automaticallyImplyLeading: false,
        title: const Text("My Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (globalCart.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => globalCart.clear()),
              child: const Text("Clear All", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: globalCart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("Your cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text("Add items to get started", style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: globalCart.length,
              itemBuilder: (context, index) {
                final item = globalCart[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(item.image, width: 75, height: 75, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(width: 75, height: 75, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text("₹${item.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _qtyButton(Icons.remove, () {
                                    setState(() {
                                      if (item.quantity > 1) item.quantity--;
                                      else globalCart.removeAt(index);
                                    });
                                  }),
                                  Container(
                                    width: 36,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                                    child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  _qtyButton(Icons.add, () => setState(() => item.quantity++)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => setState(() => globalCart.removeAt(index)),
                                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${globalCart.fold(0, (s, i) => s + i.quantity)} items", style: TextStyle(color: Colors.grey.shade600)),
                    Text("Total: ₹${CartLogic.calculateTotal().toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage())),
                    child: const Text("Place Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 16, color: const Color(0xFF2874F0)),
      ),
    );
  }
}
