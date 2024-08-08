import 'dart:async';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:subspace_blog_explorer/data/data_provider/image_data_provider.dart';
import 'package:subspace_blog_explorer/models/hive_image_model.dart';

class ImageDataProviderLocal extends ImageDataProvider {
  @override
  Uint8List? getImage(String url) {
    final box = Hive.box<HiveImageModel>("my_images");
    final imageModel = box.get(url);
    return imageModel?.data;
  }

  Future<void> addImage({
    required String url,
    required Uint8List data,
  }) async {
    final box = Hive.box<HiveImageModel>("my_images");
    final HiveImageModel imageModel = HiveImageModel(
      url: url,
      data: data,
    );
    await box.put(url, imageModel);
  }

  bool isImageSaved(String url) {
    final box = Hive.box<HiveImageModel>("my_images");
    return box.containsKey(url);
  }
}
