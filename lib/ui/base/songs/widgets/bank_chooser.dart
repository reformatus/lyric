import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/bank/bank.dart';
import 'package:lyric/services/bank/banks.dart';
import 'package:lyric/ui/common/error/card.dart';

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
                  padding: const EdgeInsets.all(8),
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
                TextButton(onPressed: () {}, child: Text('Ne mutassa többet')),
              ],
            ),
            ...value.map((bank) => BankTile(bank)),
          ],
        ),
      ),
    };
  }
}

class BankTile extends StatelessWidget {
  const BankTile(this.bank, {super.key});

  final Bank bank;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.download_for_offline_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: Material(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: InkWell(
                  onTap: () {},
                  child: Center(child: Icon(Icons.arrow_right_sharp)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
