import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider.dart';
import 'package:subspace_blog_explorer/models/blog_model.dart';
import 'package:subspace_blog_explorer/models/hive_blog_model.dart';

class BlogDataProviderLocal extends BlogDataProvider {
  @override
  List<HiveBlogModel> getBlogs() {
    final box = Hive.box<HiveBlogModel>("my_blogs");
    return box.values.toList();
  }

  Future<void> addBlog(BlogModel blog) async {
    final box = Hive.box<HiveBlogModel>("my_blogs");
    final HiveBlogModel hiveModel = HiveBlogModel(
      id: blog.id,
      title: blog.title,
      imageUrl: blog.imageUrl,
    );
    await box.put(hiveModel.id, hiveModel);
  }

  Future<void> addBlogs(List<BlogModel> blogs) async {
    final box = Hive.box<HiveBlogModel>("my_blogs");
    Map<String, HiveBlogModel> hiveModels = {
      for (int i = 0; i < blogs.length; ++i)
        blogs[i].id: HiveBlogModel(
          id: blogs[i].id,
          title: blogs[i].title,
          imageUrl: blogs[i].imageUrl,
        ),
    };
    await box.putAll(hiveModels);
  }
}
