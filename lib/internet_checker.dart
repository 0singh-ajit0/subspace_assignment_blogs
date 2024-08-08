import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetChecker {
  bool _hasInternetAccess = false;

  Future<bool> checkInternetAccess() async {
    return _hasInternetAccess = (await InternetConnection().hasInternetAccess);
  }

  bool get hasInternetAccess => _hasInternetAccess;
}
