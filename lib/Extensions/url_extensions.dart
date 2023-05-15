import '../Globals/global_settings.dart';

extension UriExtensions on Uri{
  Uri asProxyUri() {
    return Uri.parse("https://${GlobalSettings.domainName}/proxy?url=${Uri.encodeQueryComponent(toString())}");
  }
}