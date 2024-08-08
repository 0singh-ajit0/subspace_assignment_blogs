import 'package:hive_flutter/hive_flutter.dart';
import 'package:subspace_blog_explorer/models/hive_blog_model.dart';

class BlogAdapter extends TypeAdapter<HiveBlogModel> {
  @override
  HiveBlogModel read(BinaryReader reader) {
    final fields = <int, String>{
      for (int i = 0; i < 3; ++i) reader.readByte(): reader.readString(),
    };

    return HiveBlogModel(
      id: fields[0]!,
      title: fields[1]!,
      imageUrl: fields[2]!,
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HiveBlogModel obj) {
    writer
      ..writeByte(0)
      ..writeString(obj.id)
      ..writeByte(1)
      ..writeString(obj.title)
      ..writeByte(2)
      ..writeString(obj.imageUrl);
  }
}
