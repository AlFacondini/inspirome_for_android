import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:inspirome_for_android/models/inspiring_image_list.dart';

final inspiringImageListProvider =
    NotifierProvider<InspiringImageList, List<InspiringImage>>(
  () {
    return InspiringImageList();
  },
);

final inspiringImageAtIndexProvider = Provider.family<InspiringImage?, int>(
  (ref, index) {
    final list = ref.watch(inspiringImageListProvider);
    if (index < 0 || index >= list.length) {
      return null;
    } else {
      return list[index];
    }
  },
);

final inspiringImageWithGuidProvider = Provider.family<InspiringImage?, String>(
  (ref, guid) {
    return ref
        .watch(inspiringImageListProvider)
        .where(
          (element) => element.guid == guid,
        )
        .singleOrNull;
  },
);

final newInspiringImageProvider = FutureProvider<InspiringImage>(
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

    final newImage =
        ref.read(inspiringImageListProvider.notifier).addNewImage(imageUrl);

    return newImage;
  },
);

final inspiringImageBytesProvider = FutureProvider.family<Uint8List, String>(
  (ref, guid) async {
    final url = ref.watch(inspiringImageWithGuidProvider(guid).select(
      (value) => value?.imageUrl,
    ));

    if (url == null) {
      throw Exception("Invalid guid.");
    }

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

final inspiringImageListIndexProvider = StateProvider<int>(
  (ref) => 0,
);

final currentInspiringImageProvider = Provider<InspiringImage?>((ref) {
  final currentIndex = ref.watch(inspiringImageListIndexProvider);
  return ref.watch(inspiringImageAtIndexProvider(currentIndex));
});
