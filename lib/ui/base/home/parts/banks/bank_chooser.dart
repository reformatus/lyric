import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../data/bank/bank.dart';
import '../../../../../services/bank/banks.dart';
import '../../../songs/widgets/filter/types/bank/state.dart';
import '../../../../common/error/card.dart';

class BankChooser extends ConsumerWidget {
  const BankChooser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var banks = ref.watch(watchAllBanksProvider);
    return switch (banks) {
      AsyncError(:final error, :final stackTrace) => LErrorCard(
        type: LErrorType.error,
        title: 'Nem sikerült betölteni a daltárakat',
        icon: Icons.error,
        message: error.toString(),
        stack: stackTrace.toString(),
      ),
      AsyncLoading() => Center(child: CircularProgressIndicator()),
      AsyncValue<List<Bank>>(:final value!) => SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 18,
                  ),
                  child: Text(
                    'DALTÁRAK',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: FilledButton.icon(
                    iconAlignment: IconAlignment.end,
                    onPressed: () => context.go('/bank'),
                    label: Text('Összes dal'),
                    icon: Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
            ...value.map((bank) => BankTile(bank)),
          ],
        ),
      ),
    };
  }
}

class BankTile extends ConsumerWidget {
  const BankTile(this.bank, {super.key});

  final Bank bank;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 6),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 5),
                minTileHeight: 80,
                leading: SizedBox.square(
                  dimension: 80,
                  child: FittedBox(
                    child: bank.logo != null
                        ? Image.memory(bank.logo!)
                        : Icon(Icons.library_music),
                  ),
                ),
                title: Text(
                  bank.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: bank.description.isNotEmpty
                    ? Text(
                        bank.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : null,
                /*trailing: Row( // TODO download functionality
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.download_for_offline_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),*/
              ),
            ),
            SizedBox(
              width: 50,
              child: Material(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: InkWell(
                  onTap: () {
                    ref
                        .read(banksFilterStateProvider.notifier)
                        .setFilter(bank.uuid, true);
                    context.go('/bank');
                  },
                  child: Center(child: Icon(Icons.chevron_right)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
