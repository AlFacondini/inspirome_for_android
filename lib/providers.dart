import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:inspirome_for_android/models/inspiring_image_list.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathprov;

typedef SpecificImageWithTagParameters = ({String tag, int index});

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

    final appTmpDir = await pathprov.getTemporaryDirectory();
    final splittedUrl = path.split(url);
    splittedUrl.removeRange(0, splittedUrl.length - 2);
    final usefulUrl = splittedUrl.join(path.separator);
    final filePath = path.join(appTmpDir.path, usefulUrl);
    final imageFile = File(filePath);

    debugPrint("Checking cache for file '$filePath'.");
    if (!await imageFile.exists()) {
      debugPrint("Accessing image at $url.");
      final response = await http.get(Uri.parse(url));

      final statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception("Image HTTP request failed with code $statusCode");
      } else {
        debugPrint("Image HTTP request OK.");
      }

      final image = response.bodyBytes;

      if (!await imageFile.parent.exists()) {
        await imageFile.parent.create(recursive: true);
      }

      imageFile.writeAsBytes(image);

      return image;
    } else {
      debugPrint("Accessing image ${imageFile.path}.");
      return imageFile.readAsBytes();
    }
  },
);

final inspiringImageListIndexProvider = StateProvider<int>(
  (ref) => 0,
);

final currentInspiringImageProvider = Provider<InspiringImage?>((ref) {
  final currentIndex = ref.watch(inspiringImageListIndexProvider);
  return ref.watch(inspiringImageAtIndexProvider(currentIndex));
});

final selectedImageGuidProvider = StateProvider<String?>(
  (ref) => null,
);

final orderedFavouriteImageListProvider = Provider(
  (ref) {
    final ret = ref
        .watch(inspiringImageListProvider)
        .where(
          (element) => element.favourite,
        )
        .toList();
    ret.sort();
    return ret;
  },
);

final specificOrderedFavouriteImageListProvider =
    Provider.family<InspiringImage?, int>(
  (ref, arg) {
    return ref.watch(orderedFavouriteImageListProvider)[arg];
  },
);

final specificReversedFavouriteImageListProvider =
    Provider.family<InspiringImage?, int>(
  (ref, arg) {
    return ref.watch(orderedFavouriteImageListProvider).reversed.toList()[arg];
  },
);

final favouriteImageListCountProvider = Provider(
  (ref) {
    return ref.watch(orderedFavouriteImageListProvider).length;
  },
);

final tagsListProvider = Provider(
  (ref) {
    final ret = <String>{};
    for (var element in ref.watch(inspiringImageListProvider)) {
      for (var str in element.tags) {
        ret.add(str);
      }
    }
    return ret.toList();
  },
);

final specificImageWithTagProvider =
    Provider.family<InspiringImage?, SpecificImageWithTagParameters>(
  (ref, arg) {
    final ret = ref.watch(inspiringImageListProvider).where(
      (element) {
        return element.tags.contains(arg.tag);
      },
    ).toList();

    ret.sort();

    return ret.reversed.toList()[arg.index];
  },
);

final imagesWithTagCountProvider = Provider.family<int, String?>(
  (ref, arg) {
    return ref
        .watch(inspiringImageListProvider)
        .where(
          (element) {
            return element.tags.contains(arg);
          },
        )
        .toList()
        .length;
  },
);
