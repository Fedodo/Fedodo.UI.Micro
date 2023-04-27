import 'dart:math';
import 'package:fedodo_micro/APIs/OAuth/application_registration.dart';
import 'package:fedodo_micro/APIs/OAuth/login_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Views/navigation.dart';
import 'dart:collection';
import 'package:flutter/material.dart';

void main() {
  runApp(const FedodoMicro());
}

class FedodoMicro extends StatelessWidget {
  const FedodoMicro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String domainName = "dev.fedodo.social"; // TODO
    String userId = "b8c95012-c092-402c-bfa0-f2c86bd3f211"; // TODO

    LoginManager login = LoginManager(domainName);
    Future<String?> accessTokenFuture = login.login();

    return MaterialApp(
      title: 'Fedodo Micro',
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
      home: FutureBuilder<String?>(
        future: accessTokenFuture,
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Navigation(
              domainName: domainName,
              userId: "https://$domainName/actor/$userId",
              title: "Fedodo Micro",
              accessToken: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            child = const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          } else {
            child = const Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return child;
        },
      ),
    );
  }
}
