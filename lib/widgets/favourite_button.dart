import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class FavouriteButton extends ConsumerWidget {
  final String? _selectedGuid;

  const FavouriteButton(this._selectedGuid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    if (_selectedGuid == null) {
      throw Exception("Passed wrong guid to Favourite Button.");
    }

    bool? isFavourite =
        ref.watch(inspiringImageWithGuidProvider(_selectedGuid).select(
      (value) => value?.favourite,
    ));

    if (isFavourite == null) {
      throw Exception("Passed wrong guid to Favourite Button.");
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          ref
              .read(inspiringImageListProvider.notifier)
              .setFavourite(_selectedGuid);
        },
        label:
            isFavourite ? const Text("Unfavourite") : const Text("Favourite"),
        icon: isFavourite
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : const Icon(Icons.favorite_outline),
      );
    }
  }
}
