import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider_local.dart';
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider_remote.dart';
import 'package:subspace_blog_explorer/internet_checker.dart';
import 'package:subspace_blog_explorer/models/blog_model.dart';
import 'package:subspace_blog_explorer/models/hive_blog_model.dart';

class BlogRepository {
  final BlogDataProviderRemote _remoteProvider;
  final BlogDataProviderLocal _localProvider;

  BlogRepository({
    required BlogDataProviderRemote remoteProvider,
    required BlogDataProviderLocal localProvider,
  })  : _remoteProvider = remoteProvider,
        _localProvider = localProvider;

  Future<List<BlogModel>> getBlogs() async {
    try {
      var blogs = <BlogModel>[];

      if (GetIt.I.get<InternetChecker>().hasInternetAccess) {
        // Go for remote provider
        final blogsData = await _remoteProvider.getBlogs();
        final decodedData = jsonDecode(blogsData);
        final List<dynamic> blogsJson = decodedData["blogs"];

        for (var blog in blogsJson) {
          blogs.add(BlogModel.fromMap(blog as Map<String, dynamic>));
        }

        await _localProvider.addBlogs(blogs);
      } else {
        // Go for local provider
        final blogsData = _localProvider.getBlogs();
        blogs = blogsData.map(
          (HiveBlogModel hModel) {
            return BlogModel(
              id: hModel.id,
              title: hModel.title,
              imageUrl: hModel.imageUrl,
            );
          },
        ).toList();
      }

      return blogs;
    } catch (e) {
      throw e.toString();
    }
  }
}
