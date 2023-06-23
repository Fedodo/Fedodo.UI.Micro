import 'package:fedodo_micro/SuSi/OAuthHandler/custom_web_base_dummy.dart'
    if (dart.library.html) '../OAuthHandler/custom_web_base.dart';
import 'package:flutter/foundation.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:random_string/random_string.dart';
import '../../Globals/auth.dart';
import '../../Globals/preferences.dart';

class LoginManager {
  late OAuth2Client client;

  BaseWebAuth? baseWebAuth;

  LoginManager(bool isAndroid) {
    if (isAndroid) {
      client = OAuth2Client(
        authorizeUrl:
            "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/authorize",
        tokenUrl:
            "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/token",
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app",
      );
    } else {
      client = OAuth2Client(
        authorizeUrl:
            "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/authorize",
        tokenUrl:
            "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/token",
        redirectUri: AuthGlobals.redirectUriWeb,
        // refreshUrl: "https://auth.${GlobalSettings.domainName}/oauth/token",
        customUriScheme: Uri.parse(AuthGlobals.redirectUriWeb).authority,
      );
    }

    if (kIsWeb) {
      baseWebAuth = CustomWebBase();
    }
  }

  Future<String?> login(String clientId, String clientSecret) async {
    var state = Preferences.prefs?.getString("OAuth_State");
    var codeVerifier = Preferences.prefs?.getString("OAuth_CodeVerifier");

    if (kIsWeb && codeVerifier == null) {
      codeVerifier = randomAlphaNumeric(80);
      Preferences.prefs?.setString("OAuth_CodeVerifier", codeVerifier);
    }

    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(
      clientId: clientId,
      clientSecret: Uri.encodeQueryComponent(clientSecret),
      scopes: ["offline_access"],
      webAuthClient: baseWebAuth,
      state: state,
      codeVerifier: codeVerifier,
    );

    var refreshToken = tknResponse.refreshToken;
    if (refreshToken != null) {
      Preferences.prefs?.setString("RefreshToken", refreshToken);
    }

    Preferences.prefs?.setString("AccessToken", tknResponse.accessToken!);

    return tknResponse.accessToken;
  }

  Future<String?> refreshAsync() async {
    String clientId = Preferences.prefs!.getString("ClientId")!;
    String clientSecret = Preferences.prefs!.getString("ClientSecret")!;

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
