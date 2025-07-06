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
                          padding: EdgeInsetsGeometry.only(bottom: 3, top: 8),
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
                        /*Divider(height: 35),*/
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
      padding: EdgeInsetsGeometry.only(bottom: 3, top: 8),
      child: Text(title, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
