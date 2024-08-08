import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:subspace_blog_explorer/data/data_provider/image_data_provider.dart';

class ImageDataProviderRemote extends ImageDataProvider {
  @override
  Future<Uint8List?> getImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
