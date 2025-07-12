import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'card.dart';

import '../../base/home/parts/feedback/send_mail.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
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
    return AlertDialog(
      content: LErrorCard(
        type: type,
        title: title,
        message: message,
        stack: stack,
        icon: icon,
        showReportButton: false,
      ),
      actions: [
        FilledButton.tonalIcon(
          onPressed: () => sendFeedbackEmail(
            errorMessage: '$title ($message)',
            stackTrace: stack,
          ),
          label: Text('Hibajelentés'),
          icon: Icon(Icons.feedback_outlined),
        ),
        FilledButton(onPressed: context.pop, child: Text('OK')),
      ],
    );
  }
}
