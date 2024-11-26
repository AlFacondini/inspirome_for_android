import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class RatingSegmentedButton extends ConsumerWidget {
  final String? _selectedGuid;

  const RatingSegmentedButton(this._selectedGuid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    if (_selectedGuid == null) {
      throw Exception("Passed wrong guid to Rating Segmented Button.");
    }
    final score = ref.watch(
      inspiringImageWithGuidProvider(_selectedGuid).select(
        (value) {
          return value?.score;
        },
      ),
    );

    if (score == null || score > 5 || score < 1) {
      throw Exception("Invalid score (score = $score).");
    }

    return SegmentedButton(
      showSelectedIcon: true,
      selectedIcon: const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Theme.of(context).highlightColor,
      ),
      segments: const [
        ButtonSegment(
          value: 1,
          label: Text("1"),
          icon: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        ButtonSegment(
          value: 2,
          label: Text("2"),
          icon: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        ButtonSegment(
          value: 3,
          label: Text("3"),
          icon: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        ButtonSegment(
          value: 4,
          label: Text("4"),
          icon: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
        ButtonSegment(
          value: 5,
          label: Text("5"),
          icon: Icon(
            Icons.star,
            color: Colors.amber,
          ),
        ),
      ],
      selected: {score},
      onSelectionChanged: (p0) {
        ref
            .read(inspiringImageListProvider.notifier)
            .setScore(_selectedGuid, p0.first);
      },
    );
  }
}
