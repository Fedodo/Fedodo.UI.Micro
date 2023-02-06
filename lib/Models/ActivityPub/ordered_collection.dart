import 'package:fedodo_micro/Models/ActivityPub/post.dart';

class OrderedCollection<T> {
  final String context;
  final String summary;
  final String type;
  final int totalItems;
  final List<T> orderedItems;

  OrderedCollection(this.context, this.summary, this.type, this.totalItems,
      this.orderedItems);

  OrderedCollection.fromJson(Map<String, dynamic> json)
      : context = json["@context"],
        summary = json["summary"],
        type = json["type"],
        totalItems = json["totalItems"],
        orderedItems = generatePosts<T>(json["orderedItems"]);

  static List<T> generatePosts<T>(json) {
    var list = json as List;

    if (T == Post) {
      List<Post> returnList = [];

      for (var element in list) {
        returnList.add(Post.fromJson(element));
      }

      return returnList as List<T>;
    } else if (T == String){
      List<T> returnList = [];
      returnList.addAll(List<T>.from(json));

      return returnList;
    }

    return [];
  }
}
