import 'dart:typed_data';
import 'package:subspace_blog_explorer/data/data_provider/image_data_provider_local.dart';
import 'package:subspace_blog_explorer/data/data_provider/image_data_provider_remote.dart';

class ImageRepository {
  final ImageDataProviderRemote _remoteProvider;
  final ImageDataProviderLocal _localProvider;

  ImageRepository({
    required ImageDataProviderRemote remoteProvider,
    required ImageDataProviderLocal localProvider,
  })  : _remoteProvider = remoteProvider,
        _localProvider = localProvider;

  Future<Uint8List> getImage(bool hasInternetAccess, String url) async {
    try {
      Uint8List image;

      if ((!hasInternetAccess) || _localProvider.isImageSaved(url)) {
        // Go for local provider
        final data = _localProvider.getImage(url);
        if (data == null) throw Exception("No image found on this URL");
        image = data;
      } else {
        // Go for remote provider
        final data = await _remoteProvider.getImage(url);
        if (data == null) throw Exception("No image found on this URL");
        image = data;
        await _localProvider.addImage(url: url, data: image);
      }

      return image;
    } catch (e) {
      throw e.toString();
    }
  }
}
