import 'dart:convert';
import 'dart:io';
import 'package:flutter_guid/flutter_guid.dart';
import '../../Globals/global_settings.dart';
import '../../Globals/preferences.dart';
import 'package:http/http.dart' as http;

class ApplicationRegistration
{

  registerApplication() async{

    Guid id = Guid.newGuid;
    String clientId = "Fedodo.Micro_$id";

    Map<String, dynamic> body = {
      "client_name": clientId,
      "redirect_uris": Platform.isAndroid ? "my.test.app:/oauth2redirect" : "https://${GlobalSettings.domainName}/redirect.html", // TODO
      "website": "https://fedodo.org"
    };

    String json = jsonEncode(body);

    var response = await http.post(
      Uri.parse("https://auth.${GlobalSettings.domainName}/api/v1/apps"),
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