import 'package:flutter/material.dart';
import '../state/cart_state.dart';

class CheckoutPage extends StatelessWidget {const CheckoutPage({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Checkout")),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const TextField(decoration: InputDecoration(labelText: "Address")),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60), backgroundColor: Colors.green),
            onPressed: () {
              globalCart.clear();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Confirm Order", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    ),
  );
}
}