import 'package:flutter/material.dart';

import '../../../data/song/song.dart';
import '../../../services/key/get_transposed.dart';

class TransposeOverlayButton extends StatefulWidget {
  const TransposeOverlayButton({
    super.key,
    required this.song,
    required this.transpose,
    required this.overlayVisible,
  });

  final Song song;
  final dynamic transpose;
  final ValueNotifier<bool> overlayVisible;

  @override
  State<TransposeOverlayButton> createState() => _TransposeOverlayButtonState();
}

class _TransposeOverlayButtonState extends State<TransposeOverlayButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () {
        widget.overlayVisible.value = !widget.overlayVisible.value;
        setState(() {});
      },
      label: Text(
        widget.song.keyField != null
            ? getTransposedKey(
              widget.song.keyField!,
              widget.transpose.semitones,
            ).toString()
            : 'Transzponálás',
      ),
      icon: Icon(widget.overlayVisible.value ? Icons.close : Icons.unfold_more),
    );
  }
}
