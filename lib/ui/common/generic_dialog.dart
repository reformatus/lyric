import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';

class GenericDialog extends StatefulWidget {
  final String title;
  final Widget? emptyStateWidget;
  final Widget? body;
  final Widget? floatingActionButton;
  final bool hasContent;
  final double bottomPadding;

  const GenericDialog({
    super.key,
    required this.title,
    this.emptyStateWidget,
    this.body,
    this.floatingActionButton,
    this.hasContent = true,
    this.bottomPadding = 4,
  });

  @override
  State<GenericDialog> createState() => _GenericDialogState();
}

class _GenericDialogState extends State<GenericDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constants.tabletFromWidth.toDouble(),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed: context.pop, icon: Icon(Icons.close)),
            ],
            actionsPadding: EdgeInsets.only(right: 8),
          ),
          body: !widget.hasContent
              ? (widget.emptyStateWidget ?? Center(child: Text('No content')))
              : Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: widget.bottomPadding,
                  ),
                  child: widget.body ?? Container(),
                ),
          floatingActionButton: widget.floatingActionButton,
        ),
      ),
    );
  }
}

class GenericScrollableDialog extends StatefulWidget {
  final String title;
  final Widget? emptyStateWidget;
  final ScrollView? scrollView;
  final Widget? floatingActionButton;
  final bool hasContent;
  final double bottomPadding;

  const GenericScrollableDialog({
    super.key,
    required this.title,
    this.emptyStateWidget,
    this.scrollView,
    this.floatingActionButton,
    this.hasContent = true,
    this.bottomPadding = 4,
  });

  @override
  State<GenericScrollableDialog> createState() =>
      _GenericScrollableDialogState();
}

class _GenericScrollableDialogState extends State<GenericScrollableDialog> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constants.tabletFromWidth.toDouble(),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed: context.pop, icon: Icon(Icons.close)),
            ],
            actionsPadding: EdgeInsets.only(right: 8),
          ),
          body: !widget.hasContent
              ? (widget.emptyStateWidget ?? Center(child: Text('No content')))
              : Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: widget.bottomPadding,
                  ),
                  child: FadingEdgeScrollView.fromScrollView(
                    child: widget.scrollView ?? ListView(),
                  ),
                ),
          floatingActionButton: widget.floatingActionButton,
        ),
      ),
    );
  }
}
