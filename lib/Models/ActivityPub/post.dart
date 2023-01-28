import 'dart:core';

class Post {
  final List<String> to;
  final String name;
  final String summary;
  final bool sensitive;
  final String inReplyTo;
  final String content;
  final String id;
  final String type;
  final DateTime published;
  final String attributedTo;

  Post(this.to, this.name, this.summary, this.sensitive, this.inReplyTo,
      this.content, this.id, this.type, this.published, this.attributedTo);
}
