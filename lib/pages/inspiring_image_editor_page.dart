import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';

class InspiringImageEditorPage extends ConsumerWidget {
  final String? _selectedImageGuid;

  const InspiringImageEditorPage(this._selectedImageGuid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: Container(
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
