import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../execute.dart';
import '../state.dart';

class FiltersColumn extends ConsumerWidget {
  const FiltersColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filterableFieldsList = ref.watch(existingFilterableFieldsProvider).entries.toList();

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: filterableFieldsList
            .map((e) => switch (e.value.type) {
                  FieldType.multiselect || FieldType.multiselectTags => LFilterChips(
                      field: e.key,
                      fieldType: e.value.type,
                      fieldPopulatedCount: e.value.count,
                    ),
                  FieldType.pitch => LFilterPitch(),
                  _ => ListTile(
                      // todo nice error card
                      title: Text(e.key),
                      subtitle: Text('Unsupported filter type ${e.value}'),
                    ),
                })
            .toList());
  }
}

class LFilterPitch extends StatelessWidget {
  const LFilterPitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(child: Text('Pitch Filter'));
  }
}

class LFilterChips extends ConsumerStatefulWidget {
  const LFilterChips({
    required this.field,
    required this.fieldType,
    required this.fieldPopulatedCount,
    super.key,
  });

  final String field;
  final FieldType fieldType;
  final int fieldPopulatedCount;

  @override
  ConsumerState<LFilterChips> createState() => _LFilterChipsState();
}

class _LFilterChipsState extends ConsumerState<LFilterChips> {
  @override
  void initState() {
    super.initState();
    _filterChipsRowController = ScrollController();
  }

  late final ScrollController _filterChipsRowController;

  @override
  Widget build(BuildContext context) {
    var selectableValues =
        ref.watch(selectableValuesForFilterableFieldProvider(widget.field, widget.fieldType));
    var filterState = ref.watch(filterStateProvider);
    var filterStateNotifier = ref.read(filterStateProvider.notifier);

    bool active() => filterState.containsKey(widget.field);

    return Card(
      elevation: active() ? 7 : 0,
      color: active() ? Theme.of(context).colorScheme.secondaryContainer : null,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 15),
        leading: Icon(songFieldsMap[widget.field]!['icon'] ?? Icons.filter_list),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(songFieldsMap[widget.field]!['title_hu'] ?? "[Szűrő neve hiányzik]"),
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
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: FadingEdgeScrollView.fromScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _filterChipsRowController,
                    scrollDirection: Axis.horizontal,
                    itemCount: selectableValues.length,
                    itemBuilder: (context, i) {
                      String value = selectableValues[i];
                      bool selected = filterState[widget.field]?.contains(value) ?? false;
                      onSelected(bool newValue) {
                        if (newValue) {
                          filterStateNotifier.addFilter(widget.field, value);
                        } else {
                          filterStateNotifier.removeFilter(widget.field, value);
                        }
                      }

                      return LFilterChip(label: value, onSelected: onSelected, selected: selected);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        trailing: active()
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
    super.key,
  });

  final String label;
  final Function(bool) onSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: FilterChip.elevated(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}

class LCheckboxTile extends StatelessWidget {
  const LCheckboxTile({
    required this.label,
    required this.onTap,
    required this.value,
    super.key,
  });

  final String label;
  final ValueChanged<bool?> onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Checkbox(value: value, onChanged: onTap),
        title: Text(label),
        onTap: () {},
      ),
    );
  }
}
