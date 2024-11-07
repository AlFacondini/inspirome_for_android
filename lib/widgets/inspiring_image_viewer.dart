import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class InspiringImageViewer extends ConsumerWidget {
  final String url;

  const InspiringImageViewer(this.url, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(inspiringImageProvider(url));

    return imageUrl.when(
      data: (image) {
        return Image.memory(image);
      },
      error: (err, _) {
        return const Icon(Icons.error);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
