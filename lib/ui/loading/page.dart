import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../services/bank/bank_updated.dart';
import '../../services/songs/update.dart';
import '../common/error/card.dart';
import 'banner.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasEverUpdatedProvider = ref.watch(hasEverUpdatedAnythingProvider);
    hasEverUpdatedProvider.whenData((d) {
      if (d) showOnlineBanksUpdatingBanner();
    });

    final bankStates = ref.watch(updateAllBanksProvider);

    /*  Continue from loading page if either:
          App has been launched before or
          All banks finished updating
    */
    if (hasEverUpdatedProvider.valueOrNull == true ||
        bankStates.hasValue && bankStates.value!.values.every(isDone)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement('/bank');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sófár DalApp'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(),
        ),
      ),
      body: Center(
        child:
            hasEverUpdatedProvider.valueOrNull == false
                ? switch (bankStates) {
                  AsyncError(:final error, :final stackTrace) => LErrorCard(
                    type: LErrorType.error,
                    title: 'Hiba a tárak frissítése közben',
                    message: error.toString(),
                    stack: stackTrace.toString(),
                    icon: Icons.error,
                  ),
                  AsyncValue(:final value) =>
                    value == null
                        ? Center(child: CircularProgressIndicator())
                        : ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  margin: EdgeInsets.only(bottom: 15),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 16,
                                          left: 16,
                                          bottom: 13,
                                        ),
                                        child: Text(
                                          'Online tárak frissítése...',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                        ),
                                      ),
                                      LinearProgressIndicator(
                                        value: () {
                                          if (!bankStates.hasValue) {
                                            return null;
                                          }
                                          int stateCount = value.length;
                                          if (stateCount == 0) return null;

                                          int doneCount =
                                              value.values
                                                  .where(
                                                    (e) =>
                                                        e != null &&
                                                        (e.toUpdateCount ==
                                                            e.updatedCount),
                                                  )
                                                  .length;

                                          return doneCount / stateCount;
                                        }(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (bankStates.hasValue)
                                  ...value.entries.map(
                                    (e) => Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: ListTile(
                                        leading:
                                            isDone(e.value)
                                                ? Icon(Icons.check)
                                                : SizedBox.square(
                                                  dimension: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                        value: getProgress(
                                                          e.value,
                                                        ),
                                                      ),
                                                ),
                                        title: Text(
                                          e.key.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          e.value != null
                                              ? "${e.value!.updatedCount} / ${e.value!.toUpdateCount} frissítve"
                                              : "",
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                }
                : CircularProgressIndicator(),
      ),
    );
  }
}
