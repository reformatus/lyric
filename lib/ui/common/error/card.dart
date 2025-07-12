import 'package:flutter/material.dart';

import '../../base/home/parts/feedback/send_mail.dart';

class LErrorCard extends StatelessWidget {
  const LErrorCard({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.stack,
    required this.icon,
    this.showReportButton = true,
  });

  final LErrorType type;
  final String title;
  final String? message;
  final String? stack;
  final IconData icon;
  final bool showReportButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(18),
        ),
        color: Color.lerp(
          switch (type) {
            LErrorType.error => Colors.red,
            LErrorType.warning => Colors.orange,
            LErrorType.info => Colors.blue,
          },
          Theme.of(context).scaffoldBackgroundColor,
          0.8,
        ),
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
                }.withAlpha(200),
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              contentPadding: EdgeInsets.only(left: 13, right: 8),
            ),
            if (message != null || stack != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (message != null) Text(message!),
                    if (stack != null)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              stack!,
                              style: TextStyle(
                                fontFamily: 'Courier New',
                              ), // todo is available on android?
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (showReportButton)
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: FilledButton.icon(
                  onPressed: () => sendFeedbackEmail(
                    errorMessage: '$title ($message)',
                    stackTrace: stack,
                  ),
                  icon: Icon(Icons.feedback_outlined),
                  label: Text('Hibajelentés'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum LErrorType { error, warning, info }
