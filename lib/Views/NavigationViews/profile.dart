import 'package:fedodo_micro/Views/profile_view.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return ProfileView(
      accessToken: widget.accessToken,
      userId: widget.userId,
      appTitle: widget.appTitle,
      showAppBar: false,
    );
  }
}
