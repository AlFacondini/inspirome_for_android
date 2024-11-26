import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/favourite_button.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';
import 'package:inspirome_for_android/widgets/rating_segmented_button.dart';

class InspiringImageEditorPage extends ConsumerWidget {
  const InspiringImageEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    final String? selectedImageGuid = ref.read(selectedImageGuidProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(selectedImageGuidProvider.notifier).state = null;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Editing'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InspiringImageViewer(selectedImageGuid, false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: FavouriteButton(selectedImageGuid),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RatingSegmentedButton(selectedImageGuid),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
