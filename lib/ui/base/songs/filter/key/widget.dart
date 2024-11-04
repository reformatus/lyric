import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/key/filter.dart';
import 'package:lyric/ui/base/songs/filter/multiselect-tags/widgets/filters.dart';
import 'package:lyric/ui/base/songs/filter/key/state.dart';
import 'package:lyric/ui/common/error.dart';

class KeyFilterCard extends ConsumerStatefulWidget {
  const KeyFilterCard({
    required this.fieldPopulatedCount,
    super.key,
  });

  final int fieldPopulatedCount;

  @override
  ConsumerState<KeyFilterCard> createState() => _KeyFilterCardState();
}

class _KeyFilterCardState extends ConsumerState<KeyFilterCard> {
  @override
  void initState() {
    keysScrollController = ScrollController();
    pitchesScrollController = ScrollController();
    modesScrollController = ScrollController();
    super.initState();
  }

  late final ScrollController keysScrollController;
  late final ScrollController pitchesScrollController;
  late final ScrollController modesScrollController;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(keyFilterStateProvider);
    final isActive = !(state.pitches.isEmpty && state.modes.isEmpty && state.keys.isEmpty);

    final selectablePitches = ref.watch(selectablePitchesProvider);
    final selectableModes = ref.watch(selectableModesProvider);

    return Card(
      elevation: isActive ? 7 : 0,
      color: isActive ? Theme.of(context).colorScheme.secondaryContainer : null,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 15),
        leading: Icon(Icons.piano),
        trailing: isActive
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => ref.read(keyFilterStateProvider.notifier).reset(),
              )
            : null,
        title: AnimatedSize(
          duration: Durations.medium1,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              AnimatedOpacity(
                duration: Durations.medium1,
                opacity: state.keys.isEmpty ? 1 : 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Hangnem'),
                    Expanded(
                      child: Text(
                        "  ${widget.fieldPopulatedCount} kitöltve",
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.keys.isNotEmpty)
                SizedBox(
                  height: 38,
                  child: FadingEdgeScrollView.fromScrollView(
                    child: ListView(
                      controller: keysScrollController,
                      scrollDirection: Axis.horizontal,
                      children: state.keys
                          .map(
                            (e) => LFilterChip(
                              label: e.toString(),
                              onSelected: (v) => ref.read(keyFilterStateProvider.notifier).setKeyTo(e, v),
                              selected: state.keys.contains(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            chipsRow(selectablePitches),
            chipsRow(selectableModes, modes: true),
          ],
        ),
      ),
    );
  }

  Widget chipsRow(AsyncValue<List<KeyFilterSelectable>> selectables, {bool modes = false}) {
    return switch (selectables) {
      AsyncError(:final Error error) => LErrorCard(
          type: LErrorType.warning,
          title: 'Hiba a hangsoradatok lekérdezésekor',
          message: error.toString(),
          stack: error.stackTrace.toString(),
          icon: Icons.error),
      AsyncValue(:final value) => SizedBox(
          height: 38,
          child: value == null
              ? LinearProgressIndicator()
              : FadingEdgeScrollView.fromScrollView(
                  child: ListView.builder(
                    // hack, but still better than code repetition...
                    controller: modes ? modesScrollController : pitchesScrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => LFilterChip(
                      label: value[i].label,
                      selected: value[i].selected,
                      onSelected: value[i].onSelected,
                      special: value[i].addingKey,
                      leading: value[i].addingKey ? Icon(Icons.add, size: 20) : null,
                    ),
                    itemCount: value.length,
                  ),
                ),
        ),
    };
  }
}
