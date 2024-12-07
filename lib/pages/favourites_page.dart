import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';

class FavouritesPage extends ConsumerStatefulWidget {
  const FavouritesPage({super.key});

  @override
  ConsumerState<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends ConsumerState<FavouritesPage> {
  bool ascending = true;

  void reverseOrder() {
    setState(() {
      ascending = !ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building $this.");

    final imageListCount = ref.watch(favouriteImageListCountProvider);

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? buildPortrait(context, ref, imageListCount)
            : buildLandscape(context, ref, imageListCount);
      },
    );
  }

  FloatingActionButton? _reverseOrderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        reverseOrder();
      },
      tooltip: 'Reverse order',
      heroTag: "reverseButton",
      child: ascending ? const Icon(Icons.north) : const Icon(Icons.south),
    );
  }

  FloatingActionButton? _backFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      tooltip: 'Go to previous screen',
      heroTag: "backButton",
      child: const Icon(Icons.arrow_back),
    );
  }

  Widget buildPortrait(
      BuildContext context, WidgetRef ref, int imageListCount) {
    debugPrint("Building as portrait.");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Favourites"),
        actions: [
          IconButton(
              onPressed: () {
                reverseOrder();
              },
              icon: ascending
                  ? const Icon(Icons.north)
                  : const Icon(Icons.south)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
          itemCount: imageListCount,
          itemBuilder: (context, index) {
            return InspiringImageViewer(
                ascending
                    ? ref
                        .watch(
                            specificReversedFavouriteImageListProvider(index))
                        ?.guid
                    : ref
                        .watch(specificOrderedFavouriteImageListProvider(index))
                        ?.guid,
                true);
          },
        ),
      ),
    );
  }

  Widget buildLandscape(
      BuildContext context, WidgetRef ref, int imageListCount) {
    debugPrint("Building as landscape.");

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: imageListCount,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InspiringImageViewer(
                      ascending
                          ? ref
                              .watch(specificReversedFavouriteImageListProvider(
                                  index))
                              ?.guid
                          : ref
                              .watch(specificOrderedFavouriteImageListProvider(
                                  index))
                              ?.guid,
                      true);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: _reverseOrderFloatingActionButton(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Builder(builder: (context) {
                return _backFloatingActionButton(context)!;
              }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
