import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/ordered_collection.dart';

class SharesProvider{
  final String accessToken;

  SharesProvider(this.accessToken);

  Future<OrderedCollection> getShares(String postId) async {

    String formattedUrl = "https://dev.fedodo.social/shares/" + Uri.encodeQueryComponent(postId); // TODO

    http.Response response = await http.get(
        Uri.parse(formattedUrl),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection collection = OrderedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }

  Future<bool> isPostShared(String postId, String actorId) async{
    OrderedCollection shares = await getShares(postId);
    if (shares.orderedItems.where((element) => element == actorId).isEmpty){
      return false;
    } else{
      return true;
    }
  }
}