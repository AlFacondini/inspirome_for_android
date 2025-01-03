import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class InspiringImageViewer extends ConsumerWidget {
  final String? _selectedImageGuid;
  final bool _clickable;

  const InspiringImageViewer(this._selectedImageGuid, this._clickable,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    return GestureDetector(
      onTap: () {
        if (_clickable) {
          ref.read(selectedImageGuidProvider.notifier).state =
              _selectedImageGuid;
        }
      },
      onLongPress: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        final currentImage = ref.read(currentInspiringImageProvider);
        if (currentImage != null) {
          await Clipboard.setData(ClipboardData(text: currentImage.imageUrl));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(_urlCopiedSnackBar);
          }
        }
      },
      child: (_selectedImageGuid == null)
          ? _buildNewInspiringImage(context, ref)
          : _buildExistingInspiringImage(context, ref, _selectedImageGuid),
    );
  }
}

const _urlCopiedSnackBar = SnackBar(
  content: Text("Copied the url to the clipboard."),
  duration: Duration(seconds: 5),
);

Widget _buildNewInspiringImage(BuildContext context, WidgetRef ref) {
  ref.invalidate(newInspiringImageProvider);
  final imageObject = ref.watch(newInspiringImageProvider);
  return imageObject.when(
    data: (_) {
      return const Center(
        // The widget rebuilds anyway, this prevents flickering
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
    BuildContext context, WidgetRef ref, String imageGuid) {
  final imageBytes = ref.watch(inspiringImageBytesProvider(imageGuid));

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
