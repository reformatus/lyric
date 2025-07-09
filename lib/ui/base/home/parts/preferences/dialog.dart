import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/services/preferences/providers/lyrics_view_style.dart';
import '../../../../../services/preferences/preferences_parent.dart';

import '../../../../../main.dart';
import '../../../../../services/preferences/providers/general.dart';

class PreferencesDialog extends ConsumerStatefulWidget {
  const PreferencesDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<PreferencesDialog> {
  late ScrollController bodyController;

  @override
  void initState() {
    bodyController = ScrollController();
    super.initState();
  }

  // TODO factor out each section into separate widgets
  @override
  Widget build(BuildContext context) {
    final general = ref.watch(generalPreferencesProvider);
    final lyricsView = ref.watch(lyricsViewStylePreferencesProvider);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constants.tabletFromWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              title: Text('Beállítások'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(onPressed: context.pop, icon: Icon(Icons.close)),
              ],
              actionsPadding: EdgeInsets.only(right: 8),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: FadingEdgeScrollView.fromSingleChildScrollView(
                  child: SingleChildScrollView(
                    controller: bodyController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        sectionTitle('Színek'),
                        settingTitle('ALKALMAZÁS'),
                        SegmentedButton<ThemeMode>(
                          segments: ThemeMode.values
                              .map(
                                (v) => ButtonSegment(
                                  value: v,
                                  label: Text(v.title),
                                ),
                              )
                              .toList(),
                          selected: {general.appBrightness},
                          showSelectedIcon:
                              MediaQuery.of(context).size.width < 400
                              ? false
                              : true,
                          multiSelectionEnabled: false,
                          onSelectionChanged: (selection) => ref
                              .read(generalPreferencesProvider.notifier)
                              .setAppBrightness(selection.first),
                        ),
                        if (Theme.brightnessOf(context) == Brightness.dark ||
                            (MediaQuery.platformBrightnessOf(context) ==
                                    Brightness.dark &&
                                general.sheetBrightness == ThemeMode.system) ||
                            general.sheetBrightness == ThemeMode.dark)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: CheckboxListTile(
                              value: general.oledBlackBackground,
                              onChanged: (newValue) => ref
                                  .read(generalPreferencesProvider.notifier)
                                  .setOledBlackBackground(newValue ?? false),
                              title: Text('Teljesen fekete háttér'),
                            ),
                          ),

                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 3, top: 15),
                          child: Row(
                            children: [
                              Text(
                                'KOTTA',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              SizedBox(width: 4),
                              Badge(
                                label: Text('Kísérleti'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                        SegmentedButton<ThemeMode>(
                          segments: ThemeMode.values
                              .map(
                                (v) => ButtonSegment(
                                  value: v,
                                  label: Text(v.title),
                                ),
                              )
                              .toList(),
                          selected: {general.sheetBrightness},
                          multiSelectionEnabled: false,
                          showSelectedIcon:
                              MediaQuery.of(context).size.width < 400
                              ? false
                              : true,
                          onSelectionChanged: (selection) => ref
                              .read(generalPreferencesProvider.notifier)
                              .setSheetBrightness(selection.first),
                        ),
                        Divider(height: 45, thickness: 2),
                        Row(
                          children: [
                            sectionTitle('Dalszöveg és akkordok'),
                            IconButton(
                              onPressed: () => ref
                                  .read(
                                    lyricsViewStylePreferencesProvider.notifier,
                                  )
                                  .reset(),
                              icon: Icon(Icons.replay),
                              visualDensity: VisualDensity.compact,
                              iconSize: 18,
                              tooltip: 'Visszaállítás',
                            ),
                          ],
                        ),
                        settingTitle(
                          'Versszakszám mérete - ${lyricsView.verseTagSize.truncate()}',
                        ),
                        Slider(
                          value: lyricsView.verseTagSize,
                          onChanged: (newValue) => ref
                              .read(lyricsViewStylePreferencesProvider.notifier)
                              .setVerseTagSize(newValue),
                          min: 1,
                          max: 100,
                        ),
                        settingTitle(
                          'Akkordok mérete - ${lyricsView.chordsSize.truncate()}',
                        ),
                        Slider(
                          value: lyricsView.chordsSize,
                          onChanged: (newValue) => ref
                              .read(lyricsViewStylePreferencesProvider.notifier)
                              .setChordsSize(newValue),
                          min: 1,
                          max: 100,
                        ),
                        settingTitle(
                          'Dalszöveg mérete - ${lyricsView.lyricsSize.truncate()}',
                        ),
                        Slider(
                          value: lyricsView.lyricsSize,
                          onChanged: (newValue) => ref
                              .read(lyricsViewStylePreferencesProvider.notifier)
                              .setLyricsSize(newValue),
                          min: 1,
                          max: 100,
                        ),
                        settingTitle(
                          'Oszlopszélesség - ${lyricsView.verseCardColumnWidth}',
                        ),
                        Slider(
                          value: lyricsView.verseCardColumnWidth.toDouble(),
                          onChanged: (newValue) => ref
                              .read(lyricsViewStylePreferencesProvider.notifier)
                              .setVerseCardColumnWidth(newValue.round()),
                          min: 70,
                          max: 1000,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 5),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget settingTitle(String title) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 3, top: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
