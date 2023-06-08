import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class General {
  static String get fullActorId {
    var actorIds = getActorIds();

    return "https://${Preferences.prefs!.getString("DomainName")}/actor/${actorIds.first}"; // TODO
  }

  static String actorId = getActorIds().first;

  static List<String> getActorIds(){
    Map<String, dynamic> decodedToken = JwtDecoder.decode(Preferences.prefs!.getString(
      "AccessToken",
    )!);

    String result = decodedToken["actorIds"];
    
    List<String> actorIds = result.split(";");

    return actorIds;
  }
}
