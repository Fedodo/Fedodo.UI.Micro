import 'package:fedodo_micro/Globals/auth.dart';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:fedodo_micro/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SuSi/susi_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then(
    (value) {
      Preferences.prefs = value;

      runApp(
        const FedodoMicro(),
      );
    },
  );
}

class FedodoMicro extends StatelessWidget {
  const FedodoMicro({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "Fedodo Micro";

    return MaterialApp(
      title: title,
      onGenerateRoute: (settings){
        if(settings.name?.contains("code") ?? false){
          AuthGlobals.appLoginCodeRoute = settings.name;
        }

        return null;
      },
      theme: ThemeData(
        fontFamily: "Roboto",
        fontFamilyFallback: const ["NotoColorEmoji"],
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
      home: Preferences.prefs!.getString("DomainName") == null ||
              Preferences.prefs!.getString("UserId") == null ||
              Preferences.prefs!.getString("ActorId") ==
                  null //|| accessToken == null
          ? SuSiView(
              title: title,
            )
          : const Home(),
    );
  }
}
