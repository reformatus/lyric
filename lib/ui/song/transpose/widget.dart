import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/song/transpose/state.dart';

class TransposeControls extends ConsumerWidget {
  const TransposeControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transpose = ref.watch(transposeStateProvider);

    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sectionTitle(context, 'TRANSZPONÁLÁS'),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  ref.read(transposeStateProvider.notifier).down();
                },
                icon: Icon(Icons.expand_more),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      transpose.semitones.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  ref.read(transposeStateProvider.notifier).up();
                },
                icon: Icon(Icons.expand_less),
              ),
            ],
          ),
          sectionTitle(context, 'CAPO'),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  ref.read(transposeStateProvider.notifier).removeCapo();
                },
                icon: Icon(Icons.remove),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      transpose.capo.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  ref.read(transposeStateProvider.notifier).addCapo();
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 7, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
        ),
      ),
    );
  }
}
