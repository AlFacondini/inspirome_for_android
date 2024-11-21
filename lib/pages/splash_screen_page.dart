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
    return Container(
      color: Colors.red,
    );
  }

  Future<bool> _loadFavourites() async {
    final imagesAdded =
        await ref.read(inspiringImageListProvider.notifier).addJsonFavouries();

    final imageIndex = ref.read(inspiringImageListIndexProvider);

    ref.read(inspiringImageListIndexProvider.notifier).state =
        (imageIndex + imagesAdded - 1);

    return true;
  }

  void _changePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void _initialize() async {
    await _loadFavourites();
    _changePage();
  }
}
