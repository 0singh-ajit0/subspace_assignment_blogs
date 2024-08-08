import 'package:flutter/foundation.dart';
import 'package:subspace_blog_explorer/models/blog_model.dart';

@immutable
sealed class BlogState {}

final class BlogStateUninitialized extends BlogState {}

final class BlogStateInitialized extends BlogState {}

final class BlogStateLoading extends BlogState {}

final class BlogStateSuccess extends BlogState {
  final List<BlogModel> blogs;

  BlogStateSuccess({required this.blogs});
}

final class BlogStateFailure extends BlogState {
  final String error;

  BlogStateFailure({required this.error});
}
