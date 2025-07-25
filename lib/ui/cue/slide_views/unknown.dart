import 'package:flutter/material.dart';

import '../../../data/cue/slide.dart';
import '../../common/error/card.dart';

class UnknownTypeSlideTile extends StatelessWidget {
  const UnknownTypeSlideTile(
    this.slide,
    this.index, {
    required this.selectCallback,
    required this.removeCallback,
    required this.isCurrent,
    super.key,
  });

  final GestureTapCallback selectCallback;
  final GestureTapCallback removeCallback;
  final bool isCurrent;
  final Slide slide;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: index,
      child: ListTile(
        title: Text('Ismeretlen diatípus'),
        onTap: selectCallback,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: removeCallback,
              icon: Icon(Icons.delete_outline),
            ),
            ReorderableDragStartListener(
              index: index,
              child: Icon(Icons.drag_handle),
            ),
          ],
        ),
        selected: isCurrent,
        tileColor: Theme.of(context).colorScheme.errorContainer,
        selectedTileColor: Theme.of(context).colorScheme.onPrimary,
        textColor: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}

class UnknownTypeSlideView extends StatelessWidget {
  const UnknownTypeSlideView(this.slide, {super.key});

  final UnknownTypeSlide slide;

  @override
  Widget build(BuildContext context) {
    return LErrorCard(
      type: LErrorType.warning,
      title: 'Ismeretlen diatípus. Talán újabb verzióban készítették a listát?',
      icon: Icons.question_mark,
      message: slide.getPreview(),
      stack: slide.json.toString(),
    );
  }
}
