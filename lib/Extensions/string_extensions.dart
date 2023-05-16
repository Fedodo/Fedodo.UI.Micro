import '../Globals/global_settings.dart';

extension StringExtensions on String{
  String asProxyString() {
    return "https://${GlobalSettings.domainName}/proxy?url=${Uri.encodeQueryComponent(this)}";
  }
}