import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/pages/inspiring_image_editor_page.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/favourite_icons.dart';
import 'package:inspirome_for_android/widgets/home_page_viewer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    const endOfListSnackBar = SnackBar(
      content: Text("Reached the bottom of the list."),
      duration: Duration(seconds: 5),
    );

    ref.listenManual(
      selectedImageGuidProvider,
      (prev, next) {
        if (next != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const InspiringImageEditorPage(),
            ),
          );
        }
      },
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
            ScaffoldMessenger.of(context).clearSnackBars();
            ref.read(inspiringImageListIndexProvider.notifier).state =
                (imageIndex + 1);
          } else {
            // If swiping left to right
            if (details.primaryVelocity! > 0) {
              if (imageIndex > 0) {
                ref.read(inspiringImageListIndexProvider.notifier).state =
                    (imageIndex - 1);
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(endOfListSnackBar);
              }
            }
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: HomePageViewer(),
          ),
        ),
      ),
      floatingActionButton: _favouriteFloatingActionButton(ref),
    );
  }
}

FloatingActionButton? _favouriteFloatingActionButton(WidgetRef ref) {
  return FloatingActionButton(
    onPressed: () {
      final currentImage = ref.read(currentInspiringImageProvider);
      if (currentImage != null) {
        ref
            .read(inspiringImageListProvider.notifier)
            .setFavourite(currentImage.guid);
      }
    },
    tooltip: 'Favourite',
    child: const FavouriteIcons(),
  );
}
