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
        orderedItems = json["orderedItems"];
}
