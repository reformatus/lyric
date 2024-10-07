import 'package:flutter/material.dart';

class LErrorCard extends StatelessWidget {
  const LErrorCard({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.stack,
    required this.icon,
  });

  final LErrorType type;
  final String title;
  final String message;
  final String? stack;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 13),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: Icon(
              icon,
              color: switch (type) {
                LErrorType.error => Colors.red,
                LErrorType.warning => Colors.orange,
                LErrorType.info => Colors.blue,
              }.withAlpha(200),
            ),
            title: Text(message),
          ),
          if (stack != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(stack!, maxLines: 5,),
            ),
        ],
      ),
    );
  }
}

enum LErrorType {
  error,
  warning,
  info,
}
