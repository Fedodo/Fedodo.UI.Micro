import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import '../../Globals/auth.dart';
import '../../Globals/preferences.dart';

class LoginManager {
  late OAuth2Client client;

  LoginManager(bool isAndroid) {
    if (isAndroid) {
      client = OAuth2Client(
        authorizeUrl:
            "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/authorize",
        tokenUrl: "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/token",
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app",
      );
    } else {
      client = OAuth2Client(
        authorizeUrl:
            "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/authorize",
        tokenUrl: "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/token",
        redirectUri: AuthGlobals.redirectUriWeb,
        // refreshUrl: "https://auth.${GlobalSettings.domainName}/oauth/token",
        customUriScheme: Uri.parse(AuthGlobals.redirectUriWeb).authority,
      );
    }
  }

  Future<String?> login(String clientId, String clientSecret) async {
    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(
        clientId: clientId,
        clientSecret: Uri.encodeQueryComponent(clientSecret),
        scopes: ["offline_access"]);

    var refreshToken = tknResponse.refreshToken;
    if (refreshToken != null) {
      Preferences.prefs?.setString("RefreshToken", refreshToken);
    }

    Preferences.prefs?.setString("AccessToken", tknResponse.accessToken!);

    return tknResponse.accessToken;
  }

  Future<String?> refresh(String clientId, String clientSecret) async {

    var tknResponse = await client.refreshToken(
      Preferences.prefs!.getString("RefreshToken")!,
      clientId: clientId,
      clientSecret: Uri.encodeQueryComponent(clientSecret),
    );

    Preferences.prefs?.setString("AccessToken", tknResponse.accessToken!);
    Preferences.prefs?.setString("RefreshToken", tknResponse.refreshToken!);

    return tknResponse.accessToken;
  }
}
