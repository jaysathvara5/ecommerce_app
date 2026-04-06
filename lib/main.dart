import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyEcommerceApp());
}

class MyEcommerceApp extends StatelessWidget {
  const MyEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enterprise Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      // Sidha HomePage ko call karega jo pages folder mein hai
      home: HomePage(),
    );
  }
}