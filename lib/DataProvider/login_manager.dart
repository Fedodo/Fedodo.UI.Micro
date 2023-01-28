import 'package:fedodo_micro/DataProvider/application_registration.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginManager {
  void login() async {
    OAuth2Client client = OAuth2Client(
        authorizeUrl: "https://dev.fedodo.social/oauth/authorize",
        tokenUrl: "https://dev.fedodo.social/oauth/token",
        redirectUri: "my.test.app:/oauth2redirect",
        customUriScheme: "my.test.app");

    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(clientId:"app2", clientSecret: "Oxu+EVhwXuCUCt4MagLn4uraJMoCsMB3cs3lnUPZQ37QlvL0u1dBxgreI0dUaPNYKhrmwBbK7f8tYhWMWJJbrQ==");
  }
}
