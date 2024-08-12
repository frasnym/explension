import 'package:flutter/foundation.dart';

class Logger {
  logService(String serviceName, String message) {
    if (kDebugMode) {
      print("[$serviceName] called; $message");
    }
  }

  logError(String serviceName, Object err) {
    if (kDebugMode) {
      print("[$serviceName] err; $err");
    }
  }
}
