import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/favourite_button.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';
import 'package:inspirome_for_android/widgets/rating_segmented_button.dart';
import 'package:inspirome_for_android/widgets/tags_textfield.dart';

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
          child: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? buildPortrait(context, ref, selectedImageGuid)
                  : buildLandscape(context, ref, selectedImageGuid);
            },
          ),
        ),
      ),
    );
  }

  Widget buildPortrait(
      BuildContext context, WidgetRef ref, String? selectedImageGuid) {
    debugPrint("Building as portrait.");

    return SingleChildScrollView(
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
          ),
          SizedBox.fromSize(
            size: const Size(double.infinity, 3),
          ),
          Row(
            children: [
              Expanded(
                child: TagsTextfield(selectedImageGuid),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLandscape(
      BuildContext context, WidgetRef ref, String? selectedImageGuid) {
    debugPrint("Building as landscape.");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InspiringImageViewer(selectedImageGuid, false),
        SizedBox.fromSize(
          size: const Size(8, double.infinity),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
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
                ),
                Row(
                  children: [
                    Expanded(
                      child: TagsTextfield(selectedImageGuid),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
