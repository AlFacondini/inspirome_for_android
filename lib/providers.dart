import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
