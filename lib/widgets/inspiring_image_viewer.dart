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
      final imageGuid =
          ref.read(inspiringImageListElementProvider(listIndex))!.guid;
      return _buildExistingInspiringImage(context, ref, imageGuid);
    }
  }
}

Widget _buildNewInspiringImage(BuildContext context, WidgetRef ref) {
  ref.invalidate(newInspiringImageProvider);
  final imageGuid = ref.read(newInspiringImageProvider);
  return imageGuid.when(
    data: (guid) {
      return _buildExistingInspiringImage(context, ref, guid);
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
    BuildContext context, WidgetRef ref, String guid) {
  final imageBytes = ref.watch(inspiringImageProvider(guid));

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
