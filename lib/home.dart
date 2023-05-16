import 'package:flutter/material.dart';
import 'Views/navigation.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Navigation(title: "Fedodo Micro");
  }
}
