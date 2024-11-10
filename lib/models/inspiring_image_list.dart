import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class InspiringImageList extends StateNotifier<List<InspiringImage>> {
  InspiringImageList(super.state);

  String addNewImage(String url) {
    final newGuid = _uuid.v4();
    final newInspiringImage =
        InspiringImage(newGuid, url, null, DateTime.now(), false);

    debugPrint("Adding $newInspiringImage to the list.");

    state = [...state, newInspiringImage];

    return newGuid;
  }

  InspiringImage? getImageWithGuid(String guid) {
    debugPrint("Trying to retrieve image object with guid = $guid.");
    final ret = state
        .where(
          (element) => element.guid == guid,
        )
        .singleOrNull;
    if (ret == null) {
      debugPrint("Failed to retrieve image object with guid = $guid.");
    } else {
      debugPrint("Retrieved image object with guid = $guid.");
    }
    return ret;
  }
}
