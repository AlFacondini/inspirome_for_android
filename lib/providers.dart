import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:inspirome_for_android/models/inspiring_image_list.dart';

final inspiringImageUrlProvider = FutureProvider<String>(
  (ref) async {
    debugPrint("Requesting image generation to API.");
    final response =
        await http.get(Uri.parse('https://inspirobot.me/api?generate=true'));

    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw Exception("API HTTP request failed with code $statusCode.");
    } else {
      debugPrint("API HTTP request OK.");
    }

    final imageUrl = response.body;

    ref.read(inspiringImageListProvider.notifier).addImage(imageUrl);

    return imageUrl;
  },
);

final inspiringImageProvider = FutureProvider.family<Uint8List, String>(
  (ref, url) async {
    debugPrint("Accessing image at $url.");
    final response = await http.get(Uri.parse(url));

    final statusCode = response.statusCode;
    if (statusCode != 200) {
      throw Exception("Image HTTP request failed with code $statusCode");
    } else {
      debugPrint("Image HTTP request OK.");
    }

    final image = response.bodyBytes;

    return image;
  },
);

final inspiringImageListProvider =
    StateNotifierProvider<InspiringImageList, List<InspiringImage>>(
  (ref) => InspiringImageList([]),
);

final inspiringImageListIndexProvider = StateProvider<int>(
  (ref) => 0,
);

final inspiringImageListElementProvider = Provider.family<InspiringImage?, int>(
  (ref, index) {
    debugPrint("Trying to access image #$index of the list.");
    if (index >= ref.watch(inspiringImageListProvider).length) {
      debugPrint("Index out of range.");
      return null;
    } else {
      final image = ref.watch(inspiringImageListProvider).elementAt(index);
      debugPrint("Image $image found.");
      return image;
    }
  },
);

final inspiringFavouriteListIndexProvider = StateProvider<int>(
  (ref) => 0,
);

final inspiringFavouriteListElementProvider =
    Provider.family<InspiringImage?, int>(
  (ref, index) {
    debugPrint("Trying to access image #$index of the favourite list.");
    if (index >=
        ref
            .watch(inspiringImageListProvider)
            .where(
              (element) => element.favourite == true,
            )
            .length) {
      debugPrint("Index out of range.");
      return null;
    } else {
      final image = ref
          .watch(inspiringImageListProvider)
          .where(
            (element) => element.favourite == true,
          )
          .elementAt(index);
      debugPrint("Image $image found.");
      return image;
    }
  },
);

final currentInspiringImageFavouriteStatusProvider = Provider<bool>(
  (ref) {
    final listIndex = ref.watch(inspiringImageListIndexProvider);
    final favourite = ref
            .watch(inspiringFavouriteListElementProvider(listIndex))
            ?.favourite ??
        false;
    return favourite;
  },
);
