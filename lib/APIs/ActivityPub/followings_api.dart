import 'dart:convert';
import 'package:fedodo_micro/APIs/ActivityPub/actor_api.dart';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:http/http.dart' as http;
import '../../Globals/global_settings.dart';
import '../../Models/ActivityPub/actor.dart';
import '../../Models/ActivityPub/ordered_collection_page.dart';
import '../../Models/ActivityPub/ordered_paged_collection.dart';

class FollowingsAPI {
  FollowingsAPI();

  Future<OrderedPagedCollection> getFollowings(String followingsEndpoint) async {

    Uri followingsEndpointUri = Uri.parse(followingsEndpoint);

    if(followingsEndpointUri.authority != GlobalSettings.domainName){
      followingsEndpointUri = followingsEndpointUri.asProxyUri();
    }

    http.Response response = await http.get(
      followingsEndpointUri,
      headers: <String, String>{
        "Accept": "application/json"
      },
    );

    String jsonString = response.body;
    OrderedPagedCollection collection =
        OrderedPagedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }

  Future<bool> isFollowed(String followId, String actorId) async {
    ActorAPI actorAPI = ActorAPI();
    Actor actor = await actorAPI.getActor(actorId);

    OrderedPagedCollection follows = await getFollowings(actor.following!);


    do {

      String url = follows.first!;
      Uri uri = Uri.parse(url);

      if(uri.authority != GlobalSettings.domainName){
        uri = uri.asProxyUri();
      }

      http.Response response = await http.get(
        uri,
        headers: <String, String>{
          "Accept": "application/json"
        },
      );

      OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(response.body));

      if (collection.orderedItems.isEmpty){
        return false;
      }

      if (collection.orderedItems.where((element) => element == followId).isNotEmpty){
        return true;
      }

      url = collection.next!;
    } while (true);

    return false;
  }
}
