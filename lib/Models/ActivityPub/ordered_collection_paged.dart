class OrderedPagedCollection<T> {
  final String context;
  final String type;
  final String first;
  final String last;
  final int totalItems;

  OrderedPagedCollection(
      this.context, this.type, this.totalItems, this.first, this.last);

  OrderedPagedCollection.fromJson(Map<String, dynamic> json)
      : context = json["@context"],
        type = json["type"],
        totalItems = json["totalItems"],
        first = json["first"],
        last = json["last"];
}
