import 'package:flutter/material.dart';

class CenteredHint extends StatelessWidget {
  const CenteredHint(this.title, this.iconData, {super.key});

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: ListTile(leading: Icon(iconData), title: Text(title)),
      ),
    );
  }
}
