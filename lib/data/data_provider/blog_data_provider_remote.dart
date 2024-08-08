import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider.dart';

class BlogDataProviderRemote extends BlogDataProvider {
  final String _url = "https://intent-kit-16.hasura.app/api/rest/blogs";
  final String _secretKey =
      "32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6";

  @override
  Future<String> getBlogs() async {
    try {
      final res = await http.get(
        Uri.parse(_url),
        headers: {
          "x-hasura-admin-secret": _secretKey,
        },
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
