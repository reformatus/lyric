import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/ui/common/error/card.dart';

import '../../base/home/parts/feedback/send_mail.dart';

class AdaptiveErrorDialog extends StatelessWidget {
  const AdaptiveErrorDialog({
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
    return AlertDialog.adaptive(
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
          onPressed:
              () => launchFeedbackEmail(
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
