import 'dart:io';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:fedodo_micro/SuSi/APIs/login_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthBaseApi {
  static LoginManager loginManager =
      LoginManager(!kIsWeb && Platform.isAndroid);

  static Future<Response> get({
    required Uri url,
    Map<String, String>? headers,
  }) async {
    if (JwtDecoder.isExpired(Preferences.prefs!.getString("AccessToken")!)) {
      loginManager.refresh(Preferences.prefs!.getString("ClientId")!,
          Preferences.prefs!.getString("ClientSecret")!);
    }

    var headersToBeSent = <String, String>{
      "Authorization": "Bearer ${Preferences.prefs!.getString("AccessToken")}"
    };

    if (headers != null && headers.isNotEmpty) {
      headersToBeSent.addAll(headers);
    }

    var response = http.get(
      url,
      headers: headersToBeSent,
    );

    return response;
  }

  static Future<Response> post({
    required Uri url,
    required String body,
    Map<String, String>? headers,
  }) async {
    if (JwtDecoder.isExpired(Preferences.prefs!.getString("AccessToken")!)) {
      loginManager.refresh(Preferences.prefs!.getString("ClientId")!,
          Preferences.prefs!.getString("ClientSecret")!);
    }

    var headersToBeSent = <String, String>{
      "Authorization": "Bearer ${Preferences.prefs!.getString("AccessToken")}"
    };

    if (headers != null && headers.isNotEmpty) {
      headersToBeSent.addAll(headers);
    }

    var response = http.post(
      url,
      headers: headersToBeSent,
      body: body,
    );

    return response;
  }
}
