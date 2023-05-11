import 'package:fedodo_micro/Globals/global_settings.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';

class LoginManager {
  Future<String?> login(
      String clientId, String clientSecret, bool isAndroid) async {
    OAuth2Client client;

    if (isAndroid) {
      client = OAuth2Client(
        authorizeUrl:
            "https://auth.${GlobalSettings.domainName}/oauth/authorize",
        tokenUrl: "https://auth.${GlobalSettings.domainName}/oauth/token",
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app",
      );
    } else {
      client = OAuth2Client(
        authorizeUrl:
            "https://auth.${GlobalSettings.domainName}/oauth/authorize",
        tokenUrl: "https://auth.${GlobalSettings.domainName}/oauth/token",
        redirectUri: "https://${GlobalSettings.domainName}/redirect.html",
        customUriScheme: "my.test.app",
      ); // TODO
    }

    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(
      clientId: clientId,
      clientSecret: clientSecret,
    );

    if (tknResponse.accessToken != null) {
      return tknResponse.accessToken;
    } else {
      return null;
    }
  }
}
