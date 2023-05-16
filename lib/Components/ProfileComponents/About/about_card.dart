import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({
    Key? key,
    required this.name,
    required this.content,
  }) : super(key: key);

  final String name;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
