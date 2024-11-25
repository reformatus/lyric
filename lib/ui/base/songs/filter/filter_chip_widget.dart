import 'package:flutter/material.dart';

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
