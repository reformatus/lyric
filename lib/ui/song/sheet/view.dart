import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyric/data/database.dart';
import 'package:lyric/services/bank/bank_of_song.dart';
import 'package:lyric/ui/common/error.dart';

import '../../../data/bank/bank.dart';
import '../../../data/song/song.dart';

class SheetView extends ConsumerWidget {
  const SheetView(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(bankOfSongProvider(song));
    return switch (bank) {
      AsyncLoading() => CircularProgressIndicator(
          value: 0.5,
        ),
      AsyncError(:final error, :final stackTrace) => Center(
          child: LErrorCard(
              type: LErrorType.error,
              title: 'Nem találjuk az énekhez tartozó énektárat',
              message: error.toString(),
              stack: stackTrace.toString(),
              icon: Icons.error),
        ),
      AsyncValue(:final value!) => SingleChildScrollView(
          child: ConstrainedBox(
            // todo proper tablet view
            constraints: BoxConstraints(maxWidth: 900),
            child: FittedBox(
              // todo asset cache and download to disk
              // todo parse svg before display to catch errors
              child: SvgPicture.network(
                value.baseUrl.resolve(song.contentMap['svg']!).toString(),
                colorFilter:
                    ColorFilter.mode(Theme.of(context).textTheme.bodyMedium!.color!, BlendMode.srcIn),
                placeholderBuilder: (context) => CircularProgressIndicator(
                  value: 0.7,
                ),
              ),
            ),
          ),
        ),
    };
  }
}
