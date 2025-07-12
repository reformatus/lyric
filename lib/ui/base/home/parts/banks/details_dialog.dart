import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lyric/main.dart';

import '../../../../../data/bank/bank.dart';

class BankDetailsDialog extends ConsumerStatefulWidget {
  const BankDetailsDialog(this.bank, {super.key});

  final Bank bank;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BankDetailsDialogState();
}

class _BankDetailsDialogState extends ConsumerState<BankDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constants.tabletFromWidth),
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'details-${widget.bank.uuid}',
                child: Material(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: SizedBox.square(
                          dimension: 54,
                          child: FittedBox(
                            child: widget.bank.logo != null
                                ? Image.memory(widget.bank.logo!)
                                : Icon(Icons.library_music),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            widget.bank.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle:
                              widget.bank.description != null &&
                                  widget.bank.description!.isNotEmpty
                              ? Text(
                                  widget.bank.description!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : null,
                          trailing: IconButton(
                            onPressed: context.pop,
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(10, 7, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Legutóbb frissült',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      widget.bank.lastUpdated != null
                          ? DateFormat(
                              'yyyy. MM. dd. HH:mm',
                            ).format(widget.bank.lastUpdated!.toLocal())
                          : 'Még nem volt frissítve',
                    ),
                    SizedBox(height: 10),
                    if (widget.bank.legal != null &&
                        widget.bank.legal!.isNotEmpty) ...[
                      Text(
                        'Jogi nyilatkozat',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        widget.bank.legal!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 10),
                    ],
                    Text(
                      'Fejlesztés alatt...\nNézz vissza további daltárakkal kapcsolatos funkciókért később!',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
