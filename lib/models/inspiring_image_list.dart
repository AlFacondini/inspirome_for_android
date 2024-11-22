import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspirome_for_android/models/inspiring_image.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathprov;

const _uuid = Uuid();

class InspiringImageList extends Notifier<List<InspiringImage>> {
  @override
  List<InspiringImage> build() {
    return [];
  }

  InspiringImage addNewImage(String url) {
    final newInspiringImage =
        InspiringImage(_uuid.v4(), url, null, DateTime.now(), false, 0, {});

    debugPrint("Adding $newInspiringImage to the list.");

    state = [...state, newInspiringImage];

    return newInspiringImage;
  }

  int addExistingImageList(List<InspiringImage> list) {
    debugPrint("Adding multiple images to the list.");

    int imagesAdded = 0;
    final newstate = [...state];

    for (var element in list) {
      if (newstate
          .where(
            (e) => e.guid == element.guid,
          )
          .isEmpty) {
        imagesAdded++;
        newstate.add(element);
      }
    }

    state = newstate;

    return imagesAdded;
  }

  void setFavourite(String guid) {
    state = [
      for (final inspiringImage in state)
        if (inspiringImage.guid == guid)
          inspiringImage.withFavourite(!inspiringImage.favourite)
        else
          inspiringImage
    ];
    final image = state
        .where(
          (element) => element.guid == guid,
        )
        .singleOrNull;
    if (image != null) {
      if (image.favourite) {
        _addImageToJson(image);
      } else {
        _removeImageFromJson(image);
      }
    }
  }

  Future<int> addJsonFavourites() async {
    final jsonFile = await _getJsonFile();

    if (!await jsonFile.exists()) {
      await jsonFile.create(recursive: true);
    }

    final favouritesList = await _readJsonFile(jsonFile);

    return addExistingImageList(favouritesList);
  }

  Future<void> _addImageToJson(InspiringImage image) async {
    debugPrint("Adding $image to the Json file.");

    final jsonFile = await _getJsonFile();

    if (!await jsonFile.exists()) {
      await jsonFile.create(recursive: true);
    }

    final favouritesList = await _readJsonFile(jsonFile);

    if (favouritesList
        .where(
          (element) => element.guid == image.guid,
        )
        .isNotEmpty) {
      throw ("Image already present in the Json file.");
    }

    favouritesList.add(image);

    await _writeJsonFile(jsonFile, favouritesList);
  }

  Future<void> _removeImageFromJson(InspiringImage image) async {
    debugPrint("Removing $image from the Json file.");

    final jsonFile = await _getJsonFile();

    if (!await jsonFile.exists()) {
      await jsonFile.create(recursive: true);
    }

    final favouritesList = await _readJsonFile(jsonFile);

    if (favouritesList
        .where(
          (element) => element.guid == image.guid,
        )
        .isEmpty) {
      throw ("Image missing from the Json file.");
    }

    favouritesList.removeWhere(
      (element) => element.guid == image.guid,
    );

    await _writeJsonFile(jsonFile, favouritesList);
  }

  Future<File> _getJsonFile() async {
    final appDocDir = await pathprov.getApplicationDocumentsDirectory();
    final jsonFilePath = path.join(
      appDocDir.path,
      "favourites.json",
    );
    final jsonFile = File(jsonFilePath);
    return jsonFile;
  }

  Future<List<InspiringImage>> _readJsonFile(File jsonFile) async {
    final contents = await jsonFile.readAsString();

    if (contents == "") {
      return [];
    }

    List<InspiringImage> favouritesList = (json.decode(contents) as List)
        .map(
          (e) => InspiringImage.fromJson(e),
        )
        .toList();

    return favouritesList;
  }

  Future<File> _writeJsonFile(
      File jsonFile, List<InspiringImage> favouritesList) {
    return jsonFile.writeAsString(json.encode(favouritesList));
  }
}
