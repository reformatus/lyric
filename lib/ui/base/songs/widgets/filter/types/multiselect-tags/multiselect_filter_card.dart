import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../services/songs/filter.dart';
import '../../../../../../common/error/card.dart';
import '../../common/filter_chip.dart';
import '../field_type.dart';
import 'state.dart';

class MultiselectFilterCard extends ConsumerStatefulWidget {
  const MultiselectFilterCard({
    required this.field,
    required this.fieldType,
    required this.fieldPopulatedCount,
    super.key,
  });

  final String field;
  final FieldType fieldType;
  final int fieldPopulatedCount;

  @override
  ConsumerState<MultiselectFilterCard> createState() => LFilterChipsState();
}

class LFilterChipsState extends ConsumerState<MultiselectFilterCard> {
  @override
  void initState() {
    super.initState();
    _filterChipsRowController = ScrollController();
  }

  late final ScrollController _filterChipsRowController;

  @override
  Widget build(BuildContext context) {
    final selectableValues = ref.watch(
      selectableValuesForFilterableFieldProvider(
        widget.field,
        widget.fieldType,
      ),
    );
    final filterState = ref.watch(multiselectTagsFilterStateProvider);
    final filterStateNotifier = ref.read(
      multiselectTagsFilterStateProvider.notifier,
    );

    final isActive = filterState.containsKey(widget.field);

    return Card(
      elevation: isActive ? 3 : 0,
      color: isActive ? Theme.of(context).colorScheme.secondaryContainer : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading:
            !isActive
                ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    songFieldsMap[widget.field]!['icon'] ?? Icons.filter_list,
                  ),
                )
                : SizedBox(
                  width: 32,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed:
                        () =>
                            filterStateNotifier.resetFilterField(widget.field),
                    icon: Icon(Icons.clear),
                  ),
                ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // far future todo: i18n
              songFieldsMap[widget.field]!['title_hu'] ??
                  "[Szűrő neve hiányzik]",
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
            ),
          ],
        ),
        subtitle: switch (selectableValues) {
          AsyncError(:final error, :final stackTrace) => LErrorCard(
            title: 'Hiba a szűrőértékek lekérdezése közben',
            icon: Icons.warning,
            type: LErrorType.warning,
            message: error.toString(),
            stack: stackTrace.toString(),
          ),
          AsyncValue(:final value) =>
            value == null
                ? LinearProgressIndicator()
                : SizedBox(
                  height: 42,
                  child: FadingEdgeScrollView.fromScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _filterChipsRowController,
                      scrollDirection: Axis.horizontal,
                      itemCount: value.length,
                      itemBuilder: (context, i) {
                        // todo move all logic to service (like in filter/key/widget.dart)
                        String item = value[i];
                        bool selected =
                            filterState[widget.field]?.contains(item) ?? false;
                        onSelected(bool newValue) {
                          if (newValue) {
                            filterStateNotifier.addFilter(widget.field, item);
                          } else {
                            filterStateNotifier.removeFilter(
                              widget.field,
                              item,
                            );
                          }
                        }

                        return LFilterChip(
                          label: item,
                          onSelected: onSelected,
                          selected: selected,
                        );
                      },
                    ),
                  ),
                ),
        },
      ),
    );
  }
}
