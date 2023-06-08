import 'dart:io';

import 'package:fedodo_micro/APIs/ActivityPub/actor_api.dart';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:fedodo_micro/SuSi/susi_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../SuSi/APIs/login_manager.dart';

class CreateActorView extends StatelessWidget {
   CreateActorView({
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final userNameController = TextEditingController();
   final summaryController = TextEditingController();

   @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
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
            TextFormField(
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
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var token = JwtDecoder.decode(Preferences.prefs!.getString("AccessToken")!);
                  String userId = token["sub"];

                  ActorAPI actorApi = ActorAPI();
                  await actorApi.createActor(userId, userNameController.text, summaryController.text);

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
              child: const Text("Create Actor"),
            ),
          ],
        ),
      ),
    );
  }
}
