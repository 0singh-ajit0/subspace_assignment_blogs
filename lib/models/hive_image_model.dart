import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class HiveImageModel extends HiveObject {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final Uint8List data;

  HiveImageModel({
    required this.url,
    required this.data,
  });
}
