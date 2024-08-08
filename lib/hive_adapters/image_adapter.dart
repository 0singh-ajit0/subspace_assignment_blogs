import 'package:hive_flutter/hive_flutter.dart';
import 'package:subspace_blog_explorer/models/hive_image_model.dart';

class ImageAdapter extends TypeAdapter<HiveImageModel> {
  @override
  HiveImageModel read(BinaryReader reader) {
    final url = reader.readString();
    final imageData = reader.readByteList();
    final imageModel = HiveImageModel(
      url: url,
      data: imageData,
    );

    return imageModel;
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, HiveImageModel obj) {
    writer
      ..writeString(obj.url)
      ..writeByteList(obj.data);
  }
}
