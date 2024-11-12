import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:inspirome_for_android/providers.dart';

class InspiringImageViewer extends ConsumerWidget {
  const InspiringImageViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    final currentImage = ref.watch(currentInspiringImageProvider);

    if (currentImage == null) {
      return _buildNewInspiringImage(context, ref);
    } else {
      return _buildExistingInspiringImage(context, ref, currentImage);
    }
  }
}

Widget _buildNewInspiringImage(BuildContext context, WidgetRef ref) {
  ref.invalidate(newInspiringImageProvider);
  final imageObject = ref.read(newInspiringImageProvider);
  return imageObject.when(
    data: (_) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
    BuildContext context, WidgetRef ref, InspiringImage imageObject) {
  final imageBytes = ref.watch(inspiringImageProvider(imageObject));

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
