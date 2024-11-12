import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class ChangingFavouriteIcon extends ConsumerWidget {
  const ChangingFavouriteIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    final favourite = ref.watch(currentInspiringImageFavouriteStatusProvider);

    return favourite
        ? const Icon(Icons.favorite)
        : const Icon(Icons.favorite_outline);
  }
}
