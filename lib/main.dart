import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shartflix/boot.dart';
import 'package:shartflix/shartflix_app.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await BootService.initialize();
  FlutterNativeSplash.remove();
  
  runApp(const ShartflixApp());
}
