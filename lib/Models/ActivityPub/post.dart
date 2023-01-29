import 'dart:core';

class Post {
  final List<String> to;
  final String? name;
  final String? summary;
  final bool sensitive;
  final String inReplyTo;
  final String content;
  final String id;
  final String type;
  final DateTime published;
  final String attributedTo;

  Post(this.to, this.name, this.summary, this.sensitive, this.inReplyTo,
      this.content, this.id, this.type, this.published, this.attributedTo);

  Post.fromJson(Map<String, dynamic> json)
      : to = convertToStringList(json["to"]),
        name = json["name"],
        summary = json["summary"],
        sensitive = json["sensitive"],
        inReplyTo = json["inReplyTo"],
        content = json["content"],
        id = json["id"],
        type = json["type"],
        published = DateTime.parse(json["published"]),
        attributedTo = json["attributedTo"];

  static List<String> convertToStringList(json) {
    List<String> jsonList = [];

    for (var element in json){
      jsonList.add(element as String);
    }

    return jsonList;
  }
}
