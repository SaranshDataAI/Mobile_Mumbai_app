// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_mumbai/UI/splash_screen.dart';

void main() {
  runApp(const MumbaiPriceApp());
}

class MumbaiPriceApp extends StatelessWidget {
  const MumbaiPriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
