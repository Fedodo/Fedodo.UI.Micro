import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/ordered_collection.dart';

class LikesProvider{
  final String accessToken;

  LikesProvider(this.accessToken);

  Future<OrderedCollection> getLikes(String postId) async {
    
    String formattedUrl = "https://dev.fedodo.social/likes/" + Uri.encodeQueryComponent(postId); // TODO
    
    http.Response response = await http.get(
        Uri.parse(formattedUrl),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection collection = OrderedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }

  Future<bool> isPostLiked(String postId, String actorId) async{
    OrderedCollection likes = await getLikes(postId);
    if (likes.orderedItems.where((element) => element == actorId).isEmpty){
     return false;
    } else{
      return true;
    }
  }
}