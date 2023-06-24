import 'package:fedodo_general/Globals/preferences.dart';
import 'package:flutter/foundation.dart';

class AuthGlobals {
  static String get redirectUriWeb {
    if (kDebugMode) {
      return "http://localhost:8080/redirect.html";
    } else {
      return "https://micro.${Preferences.prefs!.getString("DomainName")}/redirect.html";
    }
  }
  static String? appLoginCodeRoute;
}
