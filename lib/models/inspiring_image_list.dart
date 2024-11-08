import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class InspiringImageList extends StateNotifier<List<InspiringImage>> {
  InspiringImageList(super.state);

  void addImage(String url) {
    final newInspiringImage =
        InspiringImage(_uuid.v4(), url, null, DateTime.now(), false);

    debugPrint("Adding $newInspiringImage");

    state = [...state, newInspiringImage];
  }

  void setFavourite(String guid) {
    state = [
      for (final inspiringImage in state)
        if (inspiringImage.guid == guid)
          inspiringImage.withFavourite(!inspiringImage.favourite)
        else
          inspiringImage
    ];
  }
}
