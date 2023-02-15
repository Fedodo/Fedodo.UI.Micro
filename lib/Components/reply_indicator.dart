import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReplyIndicator extends StatefulWidget {
  const ReplyIndicator({
    Key? key,
    required this.actorName,
  }) : super(key: key);

  final String actorName;

  @override
  State<ReplyIndicator> createState() => _ReplyIndicatorState();
}

class _ReplyIndicatorState extends State<ReplyIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(
            FontAwesomeIcons.reply,
            size: 18,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text("In reply to ${widget.actorName}"),
          ),
        ],
      ),
    );
  }
}
