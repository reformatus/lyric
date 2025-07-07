import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/bank/bank.dart';
import '../../main.dart';
import '../../services/songs/update.dart';
import '../common/error/card.dart';

void showOnlineBanksUpdatingBanner() {
  globals.scaffoldKey.currentState?.clearMaterialBanners();
  globals.scaffoldKey.currentState?.showMaterialBanner(
    MaterialBanner(
      content: UpdatingBanner(),
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          onPressed: () =>
              globals.scaffoldKey.currentState?.hideCurrentMaterialBanner(),
          icon: Icon(Icons.keyboard_arrow_up),
        ),
      ],
    ),
  );
}

// far future todo: show banks in scrollview, animate scroll to current, use fadingEdgeScrollView
class UpdatingBanner extends ConsumerWidget {
  const UpdatingBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankStates = ref.watch(updateAllBanksSongsProvider);

    getOverallProgress() {
      if (!bankStates.hasValue) {
        return null;
      }
      int stateCount = bankStates.requireValue.length;
      if (stateCount == 0) return null;

      int doneCount = bankStates.requireValue.values
          .where((e) => e != null && (e.toUpdateCount == e.updatedCount))
          .length;

      return doneCount / stateCount;
    }

    if (bankStates.hasValue && getOverallProgress() == 1) {
      Future.delayed(Duration(seconds: 3)).then(
        (_) => globals.scaffoldKey.currentState?.hideCurrentMaterialBanner(),
      );
    }

    return AnimatedSwitcher(
      duration: Durations.medium2,
      child: bankStates.when(
        error: (error, stackTrace) => LErrorCard(
          key: const ValueKey('error'),
          type: LErrorType.error,
          title: 'Hiba a tárak frissítése közben',
          message: error.toString(),
          stack: stackTrace.toString(),
          icon: Icons.error,
        ),
        loading: () => _buildBannerStructure(
          key: const ValueKey('loading'),
          isLoading: true,
        ),
        data: (value) => _buildBannerStructure(
          key: const ValueKey('data'),
          value: value,
          overallProgress: getOverallProgress(),
        ),
      ),
    );
  }

  Widget _buildBannerStructure({
    Key? key,
    Map<Bank, ({int toUpdateCount, int updatedCount})?>? value,
    double? overallProgress,
    bool isLoading = false,
  }) {
    Widget leading;
    String title = '';
    String message = '';

    if (isLoading) {
      leading = SizedBox.square(
        dimension: 25,
        child: CircularProgressIndicator(),
      );
    } else {
      final statesToShow = value!.entries.where((e) => e.value != null);
      final stateToShow = statesToShow.isEmpty
          ? value.entries.first
          : statesToShow.last;

      leading = isDone(stateToShow.value)
          ? Icon(Icons.check)
          : SizedBox.square(
              dimension: 25,
              child: CircularProgressIndicator(
                value: getProgress(stateToShow.value),
              ),
            );

      title = stateToShow.key.name;

      if (stateToShow.value != null) {
        if (stateToShow.value!.toUpdateCount == 0) {
          message = 'Minden friss.';
        } else {
          message =
              '${stateToShow.value!.updatedCount} / ${stateToShow.value!.toUpdateCount} frissítve';
        }
      } else {
        message = '';
      }
    }

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(value: isLoading ? null : overallProgress),
        Padding(
          padding: EdgeInsets.only(left: 10, bottom: 5),
          child: ListTile(
            leading: leading,
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(message),
          ),
        ),
      ],
    );
  }
}
