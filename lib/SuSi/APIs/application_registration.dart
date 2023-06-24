import 'dart:convert';
import 'dart:io';
import 'package:fedodo_general/Globals/preferences.dart';
import 'package:fedodo_micro/Globals/auth.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApplicationRegistration {
  registerApplication() async {
    Guid id = Guid.newGuid;
    String clientId = "Fedodo.Micro_$id";
    bool isAndroid;

    if (!kIsWeb && Platform.isAndroid) {
      isAndroid = true;
    } else {
      isAndroid = false;
    }

    Map<String, dynamic> body = {
      "client_name": clientId,
      "redirect_uris": isAndroid
          ? "my.test.app:/oauth2redirect"
          : AuthGlobals.redirectUriWeb,
      "website": "https://fedodo.org"
    };

    String json = jsonEncode(body);

    var response = await http.post(
      Uri.parse("https://auth.${Preferences.prefs!.getString("DomainName")}/api/v1/apps"),
      headers: <String, String>{
        "content-type": "application/json",
      },
      body: json,
    );

    Map<String, dynamic> result = jsonDecode(response.body);

    Preferences.prefs?.setString("ClientId", result["client_id"]);
    Preferences.prefs?.setString("ClientSecret", result["client_secret"]);
  }
}
