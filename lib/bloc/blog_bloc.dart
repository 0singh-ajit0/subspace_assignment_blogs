import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subspace_blog_explorer/bloc/blog_event.dart';
import 'package:subspace_blog_explorer/bloc/blog_state.dart';
import 'package:subspace_blog_explorer/data/repository/blog_repository.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository _blogRepository;

  BlogBloc({required BlogRepository blogRepository})
      : _blogRepository = blogRepository,
        super(BlogStateUninitialized()) {
    on<BlogEventFetch>(_getBlogs);
  }

  Future<void> _getBlogs(
    BlogEventFetch event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogStateLoading());
    try {
      final blogs = await _blogRepository.getBlogs();
      emit(BlogStateSuccess(blogs: blogs));
    } catch (e) {
      emit(BlogStateFailure(error: e.toString()));
    }
  }
}
