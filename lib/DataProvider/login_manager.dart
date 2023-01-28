import 'package:fedodo_micro/DataProvider/application_registration.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginManager {
  Future<String?> login() async {
    OAuth2Client client = OAuth2Client(
        authorizeUrl: "https://dev.fedodo.social/oauth/authorize",
        tokenUrl: "https://dev.fedodo.social/oauth/token",
        redirectUri: "my.test.app:/oauth2redirect",
        customUriScheme: "my.test.app");

    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(
        clientId: "app3",
        clientSecret:
            "FBPQAWYfdsfcE33gQkzwtHmFVm7/gef2c07vuSkYTWvW8jnFwaK55TSp1XuGQifoPnsZ6e89z2PJM98TakTegg==");

    if (tknResponse.accessToken != null) {
      return tknResponse.accessToken;
    } else {
      return null;
    }
  }
}
