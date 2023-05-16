import 'package:flutter/foundation.dart';
import 'global_settings.dart';

class AuthGlobals {
  static String get redirectUriWeb {
    if (kDebugMode) {
      return "http://localhost:8080/redirect.html";
    } else {
      return "https://micro.${GlobalSettings.domainName}/redirect.html";
    }
  }
}
