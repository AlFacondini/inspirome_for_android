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

final inspiringImageListLengthProvider = Provider(
  (ref) => ref.watch(inspiringImageListProvider).length,
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

final inspiringImageProvider = FutureProvider.family<Uint8List, InspiringImage>(
  (ref, imageObject) async {
    final url = imageObject.imageUrl;

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

final currentInspiringImageProvider = Provider<InspiringImage?>(
  (ref) {
    final currentIndex = ref.watch(inspiringImageListIndexProvider);
    final currentList = ref.watch(inspiringImageListProvider);

    if (currentIndex >= currentList.length) {
      return null;
    } else {
      return currentList[currentIndex];
    }
  },
);
