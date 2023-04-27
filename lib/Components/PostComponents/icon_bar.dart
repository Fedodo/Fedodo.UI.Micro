import 'package:flutter/material.dart';

class IconBar extends StatefulWidget {
  const IconBar({
    Key? key,
    required this.name,
    required this.count,
    required this.iconData,
  }) : super(key: key);

  final String name;
  final int count;
  final IconData iconData;

  @override
  State<IconBar> createState() => _IconBarState();
}

class _IconBarState extends State<IconBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                widget.iconData,
                size: 24.0,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.count.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
