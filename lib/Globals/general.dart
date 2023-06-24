import 'package:fedodo_general/Globals/preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class General {
  static String get fullActorId {
    return "https://${Preferences.prefs!.getString("DomainName")}/actor/$actorId";
  }

  static String get actorId {
    String? currentActorId = Preferences.prefs!.getString("CurrentActorId");

    if(currentActorId == null){
      var temp = getActorIds().first;
      actorId = temp;
      return temp;
    }
    
    return currentActorId;
  }

  static set actorId(String selectedId) {
    Preferences.prefs!.setString("CurrentActorId", selectedId);
  }


  static List<String> getActorIds(){
    Map<String, dynamic> decodedToken = JwtDecoder.decode(Preferences.prefs!.getString(
      "AccessToken",
    )!);

    String result = decodedToken["actorIds"];
    
    List<String> actorIds = result.split(";");

    return actorIds;
  }
}
