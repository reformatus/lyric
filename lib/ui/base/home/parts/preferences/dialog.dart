import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/data/preferences/preferences.dart';
import 'package:lyric/services/preferences/provider.dart';

import '../../../../../main.dart';

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

  @override
  Widget build(BuildContext context) {
    final general = ref.watch(generalPreferencesProvider);
    final song = ref.watch(songPreferencesProvider);

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
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: FadingEdgeScrollView.fromSingleChildScrollView(
                  child: SingleChildScrollView(
                    controller: bodyController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Színek',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ALKALMAZÁS',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 3),
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
                          multiSelectionEnabled: false,
                          onSelectionChanged: (selection) => ref
                              .read(generalPreferencesProvider.notifier)
                              .setAppBrightness(selection.first),
                        ),
                        if (Theme.brightnessOf(context) == Brightness.dark)
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
                        SizedBox(height: 8),
                        Text(
                          'KOTTA',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 3),
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
                          onSelectionChanged: (selection) => ref
                              .read(generalPreferencesProvider.notifier)
                              .setSheetBrightness(selection.first),
                        ),
                        Divider(),
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
}
