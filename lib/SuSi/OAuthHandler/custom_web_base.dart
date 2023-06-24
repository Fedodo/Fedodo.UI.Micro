import 'package:fedodo_general/Globals/preferences.dart';
import 'package:fedodo_micro/Globals/auth.dart';
import 'package:oauth2_client/interfaces.dart';
import 'dart:html' as html;

class CustomWebBase implements BaseWebAuth {
  @override
  Future<String> authenticate({
    required String callbackUrlScheme,
    required String url,
    required String redirectUrl,
    Map<String, dynamic>? opts,
  }) async {

    if(AuthGlobals.appLoginCodeRoute == null){
      Uri uri = Uri.parse(url);

      String state = uri.queryParameters["state"]!;

      Preferences.prefs?.setString("OAuth_State", state);

      html.window.open(url, "_self");

      await Future.delayed(const Duration(seconds: 10));

      return "";
    }else{
      Preferences.prefs?.remove("OAuth_State");
      var temp = AuthGlobals.appLoginCodeRoute;
      AuthGlobals.appLoginCodeRoute = null;

      return html.window.origin! + temp.toString();
    }


  }
}
