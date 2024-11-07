import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/providers.dart';
import 'package:inspirome_for_android/widgets/inspiring_image_viewer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $this.");

    const endOfListSnackBar = SnackBar(
      content: Text("Reached the bottom of the list."),
      duration: Duration(seconds: 5),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Inspirome'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // If swiping right to left
          if (details.primaryVelocity! < 0) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final imageIndex = ref.read(inspiringImageListIndexProvider);
            ref.read(inspiringImageListIndexProvider.notifier).state =
                (imageIndex + 1);
          } else {
            // If swiping left to right
            if (details.primaryVelocity! > 0) {
              final imageIndex = ref.read(inspiringImageListIndexProvider);
              if (imageIndex > 0) {
                ref.read(inspiringImageListIndexProvider.notifier).state =
                    (imageIndex - 1);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(endOfListSnackBar);
              }
            }
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: InspiringImageViewer(),
          ),
        ),
      ),
    );
  }
}

/*
final selectedProductIdProvider = StateProvider<String?>((ref) => null);
final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) => ProductsNotifier());

Widget build(BuildContext context, WidgetRef ref) {
  final List<Product> products = ref.watch(productsProvider);
  final selectedProductId = ref.watch(selectedProductIdProvider);

  return ListView(
    children: [
      for (final product in products)
        GestureDetector(
          onTap: () => ref.read(selectedProductIdProvider.notifier).state = product.id,
          child: ProductItem(
            product: product,
            isSelected: selectedProductId.state == product.id,
          ),
        ),
    ],
  );
}*/
