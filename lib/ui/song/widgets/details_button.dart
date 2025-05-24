import 'package:flutter/material.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({
    super.key,
    required this.summaryContent,
    required this.detailsContent,
    required this.onShowDetailsSheet,
    required this.detailsSheetScrollController,
  });

  final List<Widget> summaryContent;
  final List<Widget> detailsContent;
  final Function(BuildContext, ScrollController, List<Widget>)
  onShowDetailsSheet;
  final ScrollController detailsSheetScrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: Theme.of(context).primaryTextTheme.labelMedium,
          foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
        onPressed:
            () => onShowDetailsSheet(
              context,
              detailsSheetScrollController,
              detailsContent,
            ),
        child: Wrap(
          spacing: 10,
          children:
              summaryContent.isNotEmpty
                  ? summaryContent
                  : [const Text('Részletek')],
        ),
      ),
    );
  }
}
