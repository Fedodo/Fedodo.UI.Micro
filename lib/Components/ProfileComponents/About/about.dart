import 'package:fedodo_micro/Components/ProfileComponents/About/about_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Models/ActivityPub/actor.dart';

class About extends StatelessWidget {
  const About({
    Key? key,
    required this.actor,
  }) : super(key: key);

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (actor.published != null) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      children.add(
        AboutCard(name: "Published", content: dateFormat.format(actor.published!)),
      );
    }

    return ListView(
      children: children,
    );
  }
}
