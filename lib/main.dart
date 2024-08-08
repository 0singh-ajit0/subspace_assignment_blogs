import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_color_utilities/palettes/core_palette.dart'
    as core_palette;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:subspace_blog_explorer/bloc/blog_bloc.dart';
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider_local.dart';
import 'package:subspace_blog_explorer/data/data_provider/blog_data_provider_remote.dart';
import 'package:subspace_blog_explorer/data/data_provider/image_data_provider_local.dart';
import 'package:subspace_blog_explorer/data/data_provider/image_data_provider_remote.dart';
import 'package:subspace_blog_explorer/data/repository/blog_repository.dart';
import 'package:subspace_blog_explorer/data/repository/image_repository.dart';
import 'package:subspace_blog_explorer/hive_adapters/blog_adapter.dart';
import 'package:subspace_blog_explorer/hive_adapters/image_adapter.dart';
import 'package:subspace_blog_explorer/models/hive_blog_model.dart';
import 'package:subspace_blog_explorer/models/hive_image_model.dart';
import 'package:subspace_blog_explorer/presentation/screens/blogs_screen.dart';
import 'package:subspace_blog_explorer/internet_checker.dart';

core_palette.CorePalette? corePalette;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  corePalette = await DynamicColorPlugin.getCorePalette();

  await Hive.initFlutter();
  Hive.registerAdapter(BlogAdapter());
  Hive.registerAdapter(ImageAdapter());
  await Hive.openBox<HiveBlogModel>("my_blogs");
  await Hive.openBox<HiveImageModel>("my_images");

  GetIt.I.registerLazySingleton<ImageRepository>(
    () => ImageRepository(
      remoteProvider: ImageDataProviderRemote(),
      localProvider: ImageDataProviderLocal(),
    ),
  );
  GetIt.I.registerLazySingleton<InternetChecker>(() => InternetChecker());

  runApp(const BlogApp());
}

class BlogApp extends StatefulWidget {
  const BlogApp({super.key});

  @override
  State<BlogApp> createState() => _BlogAppState();
}

class _BlogAppState extends State<BlogApp> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    final finalColorScheme =
        corePalette?.toColorScheme(brightness: brightness) ??
            ColorScheme.fromSeed(seedColor: Colors.deepPurple);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: finalColorScheme.surface,
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: finalColorScheme,
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BlogBloc>(
            create: (context) => BlogBloc(
              blogRepository: BlogRepository(
                remoteProvider: BlogDataProviderRemote(),
                localProvider: BlogDataProviderLocal(),
              ),
            ),
          ),
        ],
        child: FutureBuilder(
          future: Future(
            () async {
              await GetIt.I.get<InternetChecker>().checkInternetAccess();
            },
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Your Blogs"),
                  centerTitle: true,
                ),
                body: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            return const BlogsScreen();
          },
        ),
      ),
    );
  }
}
