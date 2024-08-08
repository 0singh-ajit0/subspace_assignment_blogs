// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BlogModel {
  final String id;
  final String title;
  final String imageUrl;

  BlogModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  BlogModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image_url': imageUrl,
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModel.fromJson(String source) =>
      BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BlogModel(id: $id, title: $title, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant BlogModel other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ imageUrl.hashCode;
}
