import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class HiveBlogModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;

  HiveBlogModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
}
