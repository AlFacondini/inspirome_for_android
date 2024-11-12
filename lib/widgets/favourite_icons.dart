import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class FavouriteIcons extends ConsumerWidget {
  const FavouriteIcons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImage = ref.watch(currentInspiringImageProvider);
    if (currentImage == null) {
      return const Icon(Icons.question_mark);
    } else if (currentImage.favourite) {
      return const Icon(Icons.favorite);
    } else {
      return const Icon(Icons.favorite_border);
    }
  }
}
