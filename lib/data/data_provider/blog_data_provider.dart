import 'dart:async';

abstract class BlogDataProvider {
  FutureOr<dynamic> getBlogs();
}
