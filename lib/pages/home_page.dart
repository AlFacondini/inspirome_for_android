import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(inspiringImageUrlProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Inspirome'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // If swiping right to left
          if (details.primaryVelocity! < 0) {
            ref.invalidate(inspiringImageUrlProvider);
          } else {
            // If swiping left to right
            if (details.primaryVelocity! > 0) {}
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: imageUrl.when(
              data: (url) {
                return InspiringImageViewer(url);
              },
              error: (err, _) {
                return const Icon(Icons.error);
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
