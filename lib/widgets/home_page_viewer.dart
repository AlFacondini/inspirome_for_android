import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';

class HomePageViewer extends ConsumerWidget {
  const HomePageViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    final currentImageGuid = ref.watch(
      currentInspiringImageProvider.select(
        (value) => value?.guid,
      ),
    );

    return InspiringImageViewer(currentImageGuid, true);
  }
}
