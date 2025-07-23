import 'package:flutter/material.dart';
import 'package:shartflix/boot.dart';
import 'package:shartflix/shartflix_app.dart';

Future<void> main() async {
  await BootService.initialize();
  runApp(const ShartflixApp());
}
