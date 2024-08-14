import 'package:flutter/foundation.dart';

class Logger {
  info(String serviceName, String funcName, String message) {
    if (kDebugMode) {
      print("[$serviceName] called; $message");
    }
  }

  error(String serviceName, String funcName, Object err) {
    if (kDebugMode) {
      print("[$serviceName-$funcName] err; $err");
    }
  }
}
