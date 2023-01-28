import 'dart:math';
import 'package:fedodo_micro/DataProvider/application_registration.dart';
import 'package:fedodo_micro/DataProvider/login_manager.dart';
import 'package:flutter/material.dart';
import 'navigation.dart';
import 'dart:collection';
import 'package:flutter/material.dart';

void main() {
  runApp(const FedodoMicro());
}

class FedodoMicro extends StatefulWidget {
  const FedodoMicro({Key? key}) : super(key: key);

  @override
  State<FedodoMicro> createState() => _FedodoMicroState();
}

class _FedodoMicroState extends State<FedodoMicro> {
  @override
  Widget build(BuildContext context) {
    LoginManager login = LoginManager();
    Future<String?> accessTokenFuture = login.login();

    return MaterialApp(
      title: 'Fedodo Micro',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: FutureBuilder<String?>(
        future: accessTokenFuture,
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Navigation(
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
            child = const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
          return child;
        },
      ),
    );
  }
}
