import 'package:fedodo_general/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';

class ProfilePictureDetail extends StatefulWidget {
  const ProfilePictureDetail({
    Key? key,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    this.iconUrl,
  }) : super(key: key);

  final int followersCount;
  final int followingCount;
  final int postsCount;
  final String? iconUrl;

  @override
  State<ProfilePictureDetail> createState() => _ProfilePictureDetailState();
}

class _ProfilePictureDetailState extends State<ProfilePictureDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  width: 80,
                  height: 80,
                  widget.iconUrl != null
                      ? widget.iconUrl!.asFedodoProxyString()
                      : "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010"
                          .asFedodoProxyString(),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      widget.postsCount.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Posts"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.followingCount.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Following"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.followersCount.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Followers"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
