import 'package:flutter/material.dart';

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ShartflixApp',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
