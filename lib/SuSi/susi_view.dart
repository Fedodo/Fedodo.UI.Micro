import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global_settings.dart';
import '../home.dart';
import 'APIs/login_manager.dart';

class SuSiView extends StatelessWidget {
  SuSiView({
    Key? key,
    required this.title,
    required this.prefs,
  }) : super(key: key);

  final String title;
  final SharedPreferences prefs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: domainController,
              decoration: const InputDecoration(
                hintText: 'Domain',
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
                  GlobalSettings.domainName = domainController.text;
                  prefs.setString("DomainName", domainController.text);

                  LoginManager login = LoginManager();
                  GlobalSettings.accessToken = await login.login() ?? "";
                  prefs.setString("AccessToken", GlobalSettings.accessToken);

                  Map<String, dynamic> decodedToken = JwtDecoder.decode(GlobalSettings.accessToken);
                  GlobalSettings.userId = decodedToken["sub"];
                  GlobalSettings.actorId = "https://${GlobalSettings.domainName}/actor/${GlobalSettings.userId}";

                  prefs.setString("UserId", GlobalSettings.userId);
                  prefs.setString("ActorId", GlobalSettings.actorId);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
