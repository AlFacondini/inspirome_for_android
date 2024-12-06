import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/pages/inspiring_image_editor_page.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/favourite_icons.dart';
import 'package:inspirome_for_android/widgets/home_page_drawer.dart';
import 'package:inspirome_for_android/widgets/home_page_viewer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

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

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? buildPortrait(context, ref)
            : buildLandscape(context, ref);
      },
    );
  }
}

const endOfListSnackBar = SnackBar(
  content: Text("Reached the bottom of the list."),
  duration: Duration(seconds: 5),
);

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
    heroTag: "favouriteButton",
    child: const FavouriteIcons(),
  );
}

FloatingActionButton? _drawerFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Scaffold.of(context).openDrawer();
    },
    tooltip: 'Open drawer',
    heroTag: "drawerButton",
    child: const Icon(Icons.menu),
  );
}

Widget buildPortrait(BuildContext context, WidgetRef ref) {
  debugPrint("Building as portrait.");

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
    drawer: const HomePageDrawer(),
    floatingActionButton: _favouriteFloatingActionButton(ref),
  );
}

Widget buildLandscape(BuildContext context, WidgetRef ref) {
  debugPrint("Building as landscape.");

  return Scaffold(
    appBar: null,
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          GestureDetector(
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
                    ScaffoldMessenger.of(context)
                        .showSnackBar(endOfListSnackBar);
                  }
                }
              }
            },
            child: const Center(
              child: HomePageViewer(),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _favouriteFloatingActionButton(ref),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Builder(builder: (context) {
              return _drawerFloatingActionButton(context)!;
            }),
          ),
        ],
      ),
    ),
    drawer: const HomePageDrawer(),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}
