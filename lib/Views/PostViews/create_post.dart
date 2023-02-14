import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Components/user_header.dart';

class CreatePostView extends StatefulWidget {
  CreatePostView({
    Key? key,
    required this.userId,
    required this.accessToken,
  }) : super(key: key);

  final String userId;
  final String accessToken;

  Function()? buttonFunction;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.xmark),
        ),
        actions: [
          ElevatedButton(
            onPressed: widget.buttonFunction,
            child: const Text("Publish"),
          ),
        ],
      ),
      body: Column(
        children: [
          UserHeader(userId: widget.userId, accessToken: widget.accessToken),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  onChanged: (String text) {
                    if(text != ""){
                      setState(() {
                        widget.buttonFunction = () {

                        };
                      });
                    }else{
                      setState(() {
                        widget.buttonFunction = null;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Here you can type and paste freely',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
