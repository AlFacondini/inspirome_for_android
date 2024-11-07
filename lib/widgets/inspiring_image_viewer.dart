import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class InspiringImageViewer extends ConsumerWidget {
  const InspiringImageViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    final listIndex = ref.watch(inspiringImageListIndexProvider);
    final listLength = ref.watch(inspiringImageListProvider).length;

    if (listIndex >= listLength) {
      return _buildNewInspiringImage(context, ref);
    } else {
      final imageUrl =
          ref.read(inspiringImageListElementProvider(listIndex))!.imageUrl;
      return _buildExistingInspiringImage(context, ref, imageUrl);
    }
  }
}

Widget _buildNewInspiringImage(BuildContext context, WidgetRef ref) {
  ref.invalidate(inspiringImageUrlProvider);
  final imageUrl = ref.watch(inspiringImageUrlProvider);
  return imageUrl.when(
    data: (url) {
      return _buildExistingInspiringImage(context, ref, url);
    },
    error: (err, _) {
      return const Icon(Icons.error);
    },
    loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget _buildExistingInspiringImage(
    BuildContext context, WidgetRef ref, String url) {
  final imageBytes = ref.watch(inspiringImageProvider(url));

  return imageBytes.when(
    data: (image) {
      return Image.memory(image);
    },
    error: (err, _) {
      return const Icon(Icons.error);
    },
    loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
