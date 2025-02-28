import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../services/songs/update.dart';
import '../common/error.dart';

showOnlineBanksUpdatingBanner() {
  globals.scaffoldKey.currentState?.clearMaterialBanners();
  globals.scaffoldKey.currentState?.showMaterialBanner(
    MaterialBanner(
      content: UpdatingBanner(),
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          onPressed:
              () =>
                  globals.scaffoldKey.currentState?.hideCurrentMaterialBanner(),
          icon: Icon(Icons.keyboard_arrow_up),
        ),
      ],
    ),
  );
}

class UpdatingBanner extends ConsumerWidget {
  const UpdatingBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankStates = ref.watch(updateAllBanksProvider);

    getOverallProgress() {
      if (!bankStates.hasValue) {
        return null;
      }
      int stateCount = bankStates.requireValue.length;
      if (stateCount == 0) return null;

      int doneCount =
          bankStates.requireValue.values
              .where((e) => e != null && (e.toUpdateCount == e.updatedCount))
              .length;

      return doneCount / stateCount;
    }

    if (bankStates.hasValue && getOverallProgress() == 1) {
      Future.delayed(Duration(seconds: 3)).then(
        (_) => globals.scaffoldKey.currentState?.hideCurrentMaterialBanner(),
      );
    }

    switch (bankStates) {
      case AsyncError(:final error, :final stackTrace):
        return LErrorCard(
          type: LErrorType.error,
          title: 'Hiba a tárak frissítése közben',
          message: error.toString(),
          stack: stackTrace.toString(),
          icon: Icons.error,
        );
      case AsyncLoading(:final value!) || AsyncValue(:final value!):
        final statesToShow = value.entries.where((e) => e.value != null);
        final stateToShow =
            statesToShow.isEmpty ? value.entries.first : statesToShow.last;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: getOverallProgress()),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 5),
              child: ListTile(
                leading:
                    isDone(stateToShow.value)
                        ? Icon(Icons.check)
                        : SizedBox.square(
                          dimension: 25,
                          child: CircularProgressIndicator(
                            value: getProgress(stateToShow.value),
                          ),
                        ),
                title: Text(
                  stateToShow.key.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  stateToShow.value != null
                      ? "${stateToShow.value!.updatedCount} / ${stateToShow.value!.toUpdateCount} frissítve"
                      : "",
                ),
              ),
            ),
          ],
        );
    }
  }
}
