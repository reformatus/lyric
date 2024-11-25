import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/error.dart';

import '../../../../services/songs/filter.dart';
import 'field_type.dart';
import 'key/key_filter_card.dart';
import 'multiselect-tags/multiselect_filter_card.dart';

class FiltersColumn extends ConsumerWidget {
  const FiltersColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filterableFieldsList = ref.watch(existingFilterableFieldsProvider);

    return switch (filterableFieldsList) {
      AsyncError(:final error, :final stackTrace) => LErrorCard(
          type: LErrorType.error,
          title: 'Hiba a szűrők betöltése közben',
          message: error.toString(),
          stack: stackTrace.toString(),
          icon: Icons.error,
        ),
      AsyncValue(:final value) => value == null
          ? Center(child: LinearProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: value.entries
                  .map(
                    (e) => switch (e.value.type) {
                      FieldType.multiselect || FieldType.multiselectTags => MultiselectFilterCard(
                          field: e.key,
                          fieldType: e.value.type,
                          fieldPopulatedCount: e.value.count,
                        ),
                      FieldType.key => KeyFilterCard(
                          fieldPopulatedCount: e.value.count,
                        ),
                      _ => LErrorCard(
                          type: LErrorType.warning,
                          title: 'Nem támogatott szűrőtípus!',
                          message: e.value.toString(),
                          icon: Icons.filter_alt,
                        ),
                    },
                  )
                  .toList(),
            )
    };
  }
}
