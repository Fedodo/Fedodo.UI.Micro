import 'dart:math';

import 'package:fedodo_micro/DataProvider/application_registration.dart';
import 'package:fedodo_micro/DataProvider/login_manager.dart';
import 'package:flutter/material.dart';
import 'navigation.dart';

void main() {
  runApp(const FedodoMicro());
}

class FedodoMicro extends StatefulWidget {
  const FedodoMicro({Key? key}) : super(key: key);

  @override
  State<FedodoMicro> createState() => _FedodoMicroState();
}

class _FedodoMicroState extends State<FedodoMicro>
{
  @override
  Widget build(BuildContext context)
  {
    LoginManager login = LoginManager();
    login.login();

    return MaterialApp(
      title: 'Fedodo Micro',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const Navigation(title: 'Fedodo Micro'),
    );
  }
}