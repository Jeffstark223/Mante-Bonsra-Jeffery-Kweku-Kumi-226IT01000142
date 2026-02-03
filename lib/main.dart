import 'package:flutter/material.dart';
import 'screen/portfolio_screen.dart'; // Make sure this file exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity, // optional: remove if deprecated
      ),
      debugShowCheckedModeBanner: false, // optional: removes debug banner
      home: const PortfolioScreen(),
    );
  }
}
