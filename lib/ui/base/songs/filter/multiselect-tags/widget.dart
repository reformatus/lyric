import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/common/error.dart';

import '../../../../../services/songs/filter.dart';
import '../key/widget.dart';
import 'state.dart';

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
      AsyncLoading() => Center(child: LinearProgressIndicator()),
      AsyncValue(:final value) => Column(
          mainAxisSize: MainAxisSize.min,
          children: value!.entries
              .map(
                (e) => switch (e.value.type) {
                  FieldType.multiselect || FieldType.multiselectTags => FilterChips(
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

class FilterChips extends ConsumerStatefulWidget {
  const FilterChips({
    required this.field,
    required this.fieldType,
    required this.fieldPopulatedCount,
    super.key,
  });

  final String field;
  final FieldType fieldType;
  final int fieldPopulatedCount;

  @override
  ConsumerState<FilterChips> createState() => LFilterChipsState();
}

class LFilterChipsState extends ConsumerState<FilterChips> {
  @override
  void initState() {
    super.initState();
    _filterChipsRowController = ScrollController();
  }

  late final ScrollController _filterChipsRowController;

  @override
  Widget build(BuildContext context) {
    final selectableValues =
        ref.watch(selectableValuesForFilterableFieldProvider(widget.field, widget.fieldType));
    final filterState = ref.watch(multiselectTagsFilterStateProvider);
    final filterStateNotifier = ref.read(multiselectTagsFilterStateProvider.notifier);

    final active = filterState.containsKey(widget.field);

    return Card(
      elevation: active ? 3 : 0,
      color: active ? Theme.of(context).colorScheme.secondaryContainer : null,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 15),
        leading: Icon(songFieldsMap[widget.field]!['icon'] ?? Icons.filter_list),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // far future todo: i18n
              songFieldsMap[widget.field]!['title_hu'] ?? "[Szűrő neve hiányzik]",
            ),
            Expanded(
              child: Text(
                "  ${widget.fieldPopulatedCount} kitöltve",
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.end,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
              ),
            )
          ],
        ),
        subtitle: switch (selectableValues) {
          AsyncLoading() => LinearProgressIndicator(),
          AsyncError(:final error, :final stackTrace) => LErrorCard(
              title: 'Hiba a szűrőértékek lekérdezése közben',
              icon: Icons.warning,
              type: LErrorType.warning,
              message: error.toString(),
              stack: stackTrace.toString(),
            ),
          AsyncValue(:final value) => SizedBox(
              height: 38,
              child: FadingEdgeScrollView.fromScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _filterChipsRowController,
                  scrollDirection: Axis.horizontal,
                  itemCount: value!.length,
                  itemBuilder: (context, i) {
                    // todo move all logic to service (like in filter/key/widget.dart)
                    String item = value[i];
                    bool selected = filterState[widget.field]?.contains(item) ?? false;
                    onSelected(bool newValue) {
                      if (newValue) {
                        filterStateNotifier.addFilter(widget.field, item);
                      } else {
                        filterStateNotifier.removeFilter(widget.field, item);
                      }
                    }

                    return LFilterChip(label: item, onSelected: onSelected, selected: selected);
                  },
                ),
              ),
            )
        },
        trailing: active
            ? IconButton(
                onPressed: () => filterStateNotifier.resetFilterField(widget.field), icon: Icon(Icons.clear))
            : null,
      ),
    );
  }
}

class LFilterChip extends StatelessWidget {
  const LFilterChip({
    required this.label,
    required this.onSelected,
    required this.selected,
    this.leading,
    this.special = false,
    super.key,
  });

  final String label;
  final Function(bool) onSelected;
  final bool selected;
  final bool special;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: FilterChip.elevated(
        color: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.selected)) {
            if (special) return Theme.of(context).colorScheme.surfaceContainer;
            return Theme.of(context).cardColor;
          } else {
            return Theme.of(context).colorScheme.surfaceContainerHighest;
          }
        }),
        //padding: EdgeInsets.symmetric(horizontal: 8),
        labelPadding: EdgeInsets.only(left: leading != null ? 0 : 5, right: 5),
        label: Row(
          children: [
            if (leading != null) Padding(padding: EdgeInsets.only(right: 5), child: leading!),
            Text(label),
          ],
        ),
        selected: selected,
        onSelected: onSelected,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
