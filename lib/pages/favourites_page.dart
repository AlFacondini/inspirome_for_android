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
  bool ascending = false;

  void reverseOrder() {
    setState(() {
      ascending = !ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building $this.");

    final imageListCount = ref.watch(favouriteImageListCountProvider);

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
}
