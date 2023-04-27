import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';

class LoginManager {

  final String domainName;

  LoginManager(this.domainName);

  Future<String?> login() async {
    OAuth2Client client = OAuth2Client(
        authorizeUrl: "https://auth.$domainName/oauth/authorize",
        tokenUrl: "https://auth.$domainName/oauth/token",
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app"); // TODO

    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(
        clientId: "app3",
        clientSecret:
            "FBPQAWYfdsfcE33gQkzwtHmFVm7/gef2c07vuSkYTWvW8jnFwaK55TSp1XuGQifoPnsZ6e89z2PJM98TakTegg=="); // TODO

    if (tknResponse.accessToken != null) {
      return tknResponse.accessToken;
    } else {
      return null;
    }
  }
}
