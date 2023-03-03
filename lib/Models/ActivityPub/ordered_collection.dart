import 'package:fedodo_micro/Models/ActivityPub/post.dart';

import 'activity.dart';

class OrderedCollection {
  final String context;
  final String? summary;
  final String type;
  final int totalItems;
  final List<Activity> orderedItems;

  OrderedCollection(this.context, this.summary, this.type, this.totalItems,
      this.orderedItems);

  OrderedCollection.fromJson(Map<String, dynamic> json)
      : context = json["@context"],
        summary = json["summary"],
        type = json["type"],
        totalItems = json["totalItems"],
        orderedItems = generatePosts(json["orderedItems"]);

  static List<Activity> generatePosts(json) {

    if (json == null){
      return [];
    }

    var list = json as List;
    List<Activity> returnList = [];

    for (dynamic element in list) {
      if (element["type"] == "Create"){
        returnList.add(Activity<Post>.fromJson(element));
      }else if (element["type"] == "Announce"){
        returnList.add(Activity<String>.fromJson(element));
      }
    }

    return returnList;
  }
}
