import 'package:fedodo_micro/Components/profile_component.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
    required this.accessToken,
    required this.userId,
    required this.appTitle,
  }) : super(key: key);

  final String accessToken;
  final String userId;
  final String appTitle;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ),
      //   actions: [
      //     ElevatedButton(
      //       onPressed: widget.buttonFunction,
      //       child: const Text("Publish"),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          ProfileComponent(
            appTitle: widget.appTitle,
            accessToken: widget.accessToken,
            userId: widget.userId,
          ),
        ],
      ),
    );
  }
}
