import 'dart:convert';
import 'package:fedodo_general/Extensions/url_extensions.dart';
import 'package:http/http.dart' as http;

class WebfingerApi {
  Future<String> getUser(String input) async {
    String domain = input.split("@")[1];

    var resp = await http.get(
        Uri.parse("https://$domain/.well-known/webfinger?resource=acct:$input")
            .asFedodoProxyUri());

    var result = jsonDecode(resp.body);
    var links = result["links"];
    var profileId = links.first["href"];

    return profileId;
  }
}
