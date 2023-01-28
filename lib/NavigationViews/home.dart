import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.accessToken}) : super(key: key);

  final String accessToken;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    InboxProvider provider = InboxProvider(widget.accessToken);

    provider.getPosts();

    return const Text("Home");
  }
}
