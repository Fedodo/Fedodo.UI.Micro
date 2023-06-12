import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_micro/APIs/ActivityPub/actor_api.dart';
import 'package:fedodo_micro/Extensions/string_extensions.dart';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CreateActorView extends StatelessWidget {
  CreateActorView({
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fedodo Micro",
          style: TextStyle(
            fontFamily: "Righteous",
            fontSize: 25,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        width: 160,
                        height: 160,
                        imageUrl:
                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010"
                                .asProxyString(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        hintText: 'Name of the profile',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      maxLines: 14,
                      controller: summaryController,
                      decoration: const InputDecoration(
                        hintText: 'Description of your profile',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(width, 60),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var token = JwtDecoder.decode(
                          Preferences.prefs!.getString("AccessToken")!);
                      String userId = token["sub"];

                      ActorAPI actorApi = ActorAPI();
                      await actorApi.createActor(userId,
                          userNameController.text, summaryController.text);

                      // TODO Not sure if this works
                      // String clientId = Preferences.prefs!.getString("ClientId")!;
                      // String clientSecret = Preferences.prefs!.getString("ClientSecret")!;
                      //
                      // LoginManager login = LoginManager(!kIsWeb && Platform.isAndroid);
                      // Preferences.prefs!
                      //     .setString("AccessToken", (await login.login(clientId, clientSecret))!);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Create Profile",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
