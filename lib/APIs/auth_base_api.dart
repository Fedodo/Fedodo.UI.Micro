import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Globals/global_settings.dart';

class AuthBaseApi {
  static Future<Response> get({required Uri url, Map<String, String>? headers}) async {

    var headersToBeSent = <String, String>{
      "Authorization": "Bearer ${GlobalSettings.accessToken}"
    };

    if(headers != null && headers.isNotEmpty){
      headersToBeSent.addAll(headers);
    }

    var response = http.get(
      url,
      headers: headersToBeSent,
    );

    return response;
  }

  static Future<Response> post({required Uri url, required String body, Map<String, String>? headers}) async {

    var headersToBeSent = <String, String>{
      "Authorization": "Bearer ${GlobalSettings.accessToken}"
    };

    if(headers != null && headers.isNotEmpty){
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
