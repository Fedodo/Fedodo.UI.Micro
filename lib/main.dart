import 'package:fedodo_micro/SuSi/APIs/login_manager.dart';
import 'package:fedodo_micro/global_settings.dart';
import 'package:fedodo_micro/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SuSi/susi_view.dart';
import 'Views/navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then(
    (value) {
      runApp(
        FedodoMicro(prefs: value),
      );
    },
  );
}

class FedodoMicro extends StatelessWidget {
  const FedodoMicro({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    String? domainName = prefs.getString("DomainName");
    String? userId = prefs.getString("UserId");
    String? actorId = prefs.getString("ActorId");
    String? accessToken = prefs.getString("AccessToken");

    GlobalSettings.domainName = domainName ?? "";
    GlobalSettings.userId = userId ?? "";
    GlobalSettings.actorId = actorId ?? "";
    GlobalSettings.accessToken = accessToken ?? "";

    String title = "Fedodo Micro";

    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color.fromARGB(255, 1, 76, 72),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // elevation: 5000, // Does not seem to do anything. Oh I see... There is a bug on GitHub
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 1, 76, 72),
          enableFeedback: true,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            size: 30,
            color: Colors.white,
          ),
          unselectedIconTheme: IconThemeData(
            size: 30,
            color: Colors.white54,
          ),
        ),
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(),
            centerTitle: true,
            color: Color.fromARGB(255, 1, 76, 72),
            elevation: 0.5,
            scrolledUnderElevation: 0.5,
            shadowColor: Colors.black,
            titleTextStyle: TextStyle(
              fontFamily: "Righteous",
              fontSize: 25,
              fontWeight: FontWeight.w100,
            )),
      ),
      home: domainName == null || userId == null || actorId == null //|| accessToken == null
          ? SuSiView(
              title: title,
              prefs: prefs,
            )
          : const Home(),
    );
  }
}
