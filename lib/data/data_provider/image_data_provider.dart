import 'dart:async';
import 'dart:typed_data';

abstract class ImageDataProvider {
  FutureOr<Uint8List?> getImage(String url);
}
