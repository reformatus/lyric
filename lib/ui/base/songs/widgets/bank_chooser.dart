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
      AsyncValue<List<Bank>>(:final value!) => ListView.builder(
        itemBuilder: (context, i) => BankTile(value[i]),
        itemCount: value.length,
      ),
    };
  }
}

class BankTile extends StatelessWidget {
  const BankTile(this.bank, {super.key});

  final Bank bank;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(bank.name)));
  }
}
