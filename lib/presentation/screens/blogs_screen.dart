import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import 'package:subspace_blog_explorer/bloc/blog_bloc.dart';
import 'package:subspace_blog_explorer/bloc/blog_event.dart';
import 'package:subspace_blog_explorer/bloc/blog_state.dart';
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider_local.dart';
import 'package:subspace_blog_explorer/data/repository/image_repository.dart';
import 'package:subspace_blog_explorer/internet_checker.dart';
import 'package:subspace_blog_explorer/models/blog_model.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  late FToast fToast;
  final local = BlogDataProviderLocal();

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);
    context.read<BlogBloc>().add(BlogEventFetch());
  }

  void _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
      ),
      child: Text(message),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() async {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Blogs"),
        centerTitle: true,
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogStateFailure) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is! BlogStateSuccess) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final List<BlogModel> blogs = state.blogs;
          blogs.sort(
            (a, b) {
              return a.id.compareTo(b.id);
            },
          );

          if (blogs.isEmpty) {
            return const Center(
              child: Text(
                "No blogs to show",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: blogs.length,
            physics: const RangeMaintainingScrollPhysics(),
            itemBuilder: (context, index) {
              final blog = blogs[index];

              return GestureDetector(
                onLongPress: () {
                  _showToast(blog.title);
                },
                child: BlogListItem(blog: blog),
              );
            },
          );
        },
      ),
    );
  }
}

class BlogListItem extends StatelessWidget {
  const BlogListItem({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: Future(
                  () async {
                    final image = GetIt.I.get<ImageRepository>().getImage(
                          GetIt.I.get<InternetChecker>().hasInternetAccess,
                          blog.imageUrl,
                        );
                    return image;
                  },
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  final image = snapshot.data!;

                  return Image.memory(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                blog.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
