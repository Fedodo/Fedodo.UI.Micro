import 'dart:convert';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Globals/global_settings.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:http/http.dart' as http;

class OutboxAPI {
  Future<OrderedPagedCollection> getFirstPage(String outboxUrl) async {

    Uri outboxUri = Uri.parse(outboxUrl);

    if(outboxUri.authority != GlobalSettings.domainName){
      outboxUri = outboxUri.asProxyUri();
    }

    http.Response pageResponse = await http.get(outboxUri);
    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(pageResponse.body));
    return collection;
  }

  Future<OrderedCollectionPage> getPosts(String nextUrl) async {

    Uri nextUri = Uri.parse(nextUrl);

    if(nextUri.authority != GlobalSettings.domainName){
      nextUri = nextUri.asProxyUri();
    }

    http.Response pageResponse = await http.get(nextUri);

    String jsonString = pageResponse.body;

    OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(jsonString));

    return collection;
  }
}
