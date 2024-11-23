import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/cue/slide.dart';
import 'package:lyric/services/cue/from_id.dart';
import 'package:lyric/ui/common/error.dart';

class CuePage extends ConsumerStatefulWidget {
  const CuePage(this.cueId, {super.key});

  final int cueId;
  final int? initialSlideIndex;

  @override
  ConsumerState<CuePage> createState() => _CuePageState();
}

class _CuePageState extends ConsumerState<CuePage> {
  int? selectedSlideIndex;

  @override
  void initState() {
    selectedSlideIndex = widget.initialSlideIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cue = ref.watch(revivedCueFromIdProvider(widget.cueId));

    return Scaffold(
        appBar: AppBar(
          title: Text(cue.value?.title ?? ''),
        ),
        body: switch (cue) {
          AsyncError(:final error, :final stackTrace) => LErrorCard(
              type: LErrorType.error,
              title: 'Nem sikerült betölteni a listát!',
              icon: Icons.error,
              message: error.toString(),
              stack: stackTrace.toString(),
            ),
          AsyncLoading() => Center(
              child: CircularProgressIndicator(),
            ),
          AsyncValue(:final value!) => ListView(
              children: value.slides!.map((e) => CueSlideTile(e)).toList(),
            )
        });
  }
}

class CueSlideTile extends StatelessWidget {
  const CueSlideTile(this.slide, {super.key});

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(slide.getPreview()),
    );
  }
}
