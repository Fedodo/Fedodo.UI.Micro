import 'package:flutter/material.dart';

class ProfileNameRow extends StatefulWidget {
  const ProfileNameRow({
    Key? key,
    required this.preferredUsername,
    required this.userId,
    required this.name,
  }) : super(key: key);

  final String preferredUsername;
  final String userId;
  final String? name;

  @override
  State<ProfileNameRow> createState() => _ProfileNameRowState();
}

class _ProfileNameRowState extends State<ProfileNameRow> {
  @override
  Widget build(BuildContext context) {
    String fullUserName =
        "@${widget.preferredUsername}@${Uri.parse(widget.userId).authority}";

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name ?? "",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                fullUserName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Do Something"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
