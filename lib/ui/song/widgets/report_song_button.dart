import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/bank/bank_of_song.dart';
import 'package:lyric/services/bank/report_song.dart';

import '../../../data/song/song.dart';

class ReportSongButton extends ConsumerWidget {
  const ReportSongButton(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (song.sourceBank == null) {
      return SizedBox.shrink();
    }

    final bank = ref.watch(bankOfSongProvider(song));

    return bank.when(
      data: (bank) {
        if (bank.contactEmail != null && bank.contactEmail!.isNotEmpty) {
          return TextButton.icon(
            onPressed: () => bank.sendReportEmail(song),
            label: Text('Hibajelentés'),
            icon: Icon(Icons.textsms_outlined),
          );
        } else {
          return SizedBox.shrink();
        }
      },
      error: (error, stack) => SizedBox.shrink(),
      loading: () => SizedBox.shrink(),
    );
  }
}
