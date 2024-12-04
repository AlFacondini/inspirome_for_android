import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/pages/home_page.dart';
import 'package:inspirome_for_android/providers.dart';

class SplashScreenPage extends ConsumerStatefulWidget {
  const SplashScreenPage({super.key});

  @override
  ConsumerState<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends ConsumerState<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.inversePrimary,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Inspirome",
              style: TextStyle(
                  fontSize: 56,
                  fontFamily: "StyleScript",
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            Text(
              "for Android",
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: "Orbitron",
                  color: Theme.of(context).colorScheme.onSurface),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _loadFavourites() async {
    final imagesAdded =
        await ref.read(inspiringImageListProvider.notifier).addJsonFavourites();

    final imageIndex = ref.read(inspiringImageListIndexProvider);

    int newState = (imageIndex + imagesAdded - 1);

    if (newState < 0) {
      newState = 0;
    }

    ref.read(inspiringImageListIndexProvider.notifier).state = newState;

    return true;
  }

  void _changePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void _initialize() async {
    final begin = DateTime.now();

    await _loadFavourites();

    final end = DateTime.now();
    final timeElapsed = end.difference(begin);
    final timeToWait = const Duration(seconds: 3) - timeElapsed;

    if (!timeToWait.isNegative) {
      await Future.delayed(timeToWait);
    }

    _changePage();
  }
}
