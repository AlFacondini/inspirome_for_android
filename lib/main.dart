import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/pages/splash_screen_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspirome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        useMaterial3: true,
      ),
      home: const SplashScreenPage(),
    );
  }
}
