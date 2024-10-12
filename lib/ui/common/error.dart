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
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        color: Color.lerp(
            switch (type) {
              LErrorType.error => Colors.red,
              LErrorType.warning => Colors.orange,
              LErrorType.info => Colors.blue,
            },
            Theme.of(context).scaffoldBackgroundColor,
            0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Icon(
                icon,
                color: switch (type) {
                  LErrorType.error => Colors.red,
                  LErrorType.warning => Colors.orange,
                  LErrorType.info => Colors.blue,
                }
                    .withOpacity(0.8),
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (stack != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(message),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            stack!,
                            style: TextStyle(fontFamily: 'Courier New'), // todo is available on android?
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum LErrorType {
  error,
  warning,
  info,
}
