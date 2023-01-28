import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.accessToken}) : super(key: key);

  final String accessToken;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Text("Profile");
  }
}
