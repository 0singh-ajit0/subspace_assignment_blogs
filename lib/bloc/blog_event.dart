import 'package:flutter/foundation.dart';

@immutable
sealed class BlogEvent {}

final class BlogEventFetch extends BlogEvent {}
