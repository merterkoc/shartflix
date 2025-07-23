import 'package:flutter/material.dart';

void main() {
  runApp(const ShartflixApp());
}

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ShartflixApp', home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
