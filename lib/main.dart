import 'package:animated_number_selector_flutter/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animated Number Selector',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}