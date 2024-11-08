import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    const endOfListSnackBar = SnackBar(
      content: Text("Reached the bottom of the list."),
      duration: Duration(seconds: 5),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Inspirome'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          final imageIndex = ref.read(inspiringImageListIndexProvider);
          // If swiping right to left
          if (details.primaryVelocity! < 0) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ref.read(inspiringImageListIndexProvider.notifier).state =
                (imageIndex + 1);
          } else {
            // If swiping left to right
            if (details.primaryVelocity! > 0) {
              if (imageIndex > 0) {
                ref.read(inspiringImageListIndexProvider.notifier).state =
                    (imageIndex - 1);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(endOfListSnackBar);
              }
            }
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: InspiringImageViewer(),
          ),
        ),
      ),
      floatingActionButton: _favouriteFloatingActionButton(),
    );
  }
}

FloatingActionButton _favouriteFloatingActionButton() {
  return FloatingActionButton(
    onPressed: () {},
    tooltip: 'Favourite',
    child: const Icon(Icons.favorite_outline),
  );
}
