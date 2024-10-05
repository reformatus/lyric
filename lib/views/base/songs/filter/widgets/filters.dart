import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../execute.dart';
import '../state.dart';

class FiltersColumn extends ConsumerWidget {
  const FiltersColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filterableFieldsList = existingFilterableFields().entries.toList();

    return Column(
        children: filterableFieldsList
            .map((e) => switch (e.value.type) {
                  FieldType.multiselectChips => LFilterChips(
                      icon: songFieldsMap[e.key]!['icon'],
                      title: songFieldsMap[e.key]!['title_hu'],
                      filterChildren: []),
                  FieldType.multiselectSearch => LFilterSearch(
                      icon: songFieldsMap[e.key]!['icon'],
                      title: songFieldsMap[e.key]!['title_hu'],
                      filterChildren: []),
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
    return Placeholder(child: Text('Filter Pitch'));
  }
}

class LFilterSearch extends StatelessWidget {
  const LFilterSearch({
    required this.icon,
    required this.title,
    required this.filterChildren,
    super.key,
  });

  final IconData icon;
  final String title;
  final List<Widget> filterChildren; // todo records (tag, enabled)

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // todo implement
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text('NOT IMPLEMENTED'),
    );
  }
}

class LFilterChips extends StatelessWidget {
  const LFilterChips({
    required this.icon,
    required this.title,
    required this.filterChildren,
    super.key,
  });

  final IconData icon;
  final String title;
  final List<Widget> filterChildren; // todo records (tag, enabled)

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 15),
      leading: Icon(icon),
      title: Text(title),
      subtitle: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filterChildren,
          ),
        ),
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
  final ValueChanged<bool?> onSelected;
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
