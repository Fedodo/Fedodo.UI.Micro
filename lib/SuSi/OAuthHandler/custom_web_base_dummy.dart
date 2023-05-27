import 'package:oauth2_client/interfaces.dart';

class CustomWebBase implements BaseWebAuth {
  @override
  Future<String> authenticate({
    required String callbackUrlScheme,
    required String url,
    required String redirectUrl,
    Map<String, dynamic>? opts,
  }) {
    // TODO: implement authenticate
    throw UnimplementedError();
  }
}
