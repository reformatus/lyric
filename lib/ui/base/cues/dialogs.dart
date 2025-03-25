import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/cue/cue.dart';
import '../../../services/cue/write_cue.dart';

class EditCueDialog extends StatefulWidget {
  /// If cue is null, dialog adds new cue
  const EditCueDialog({this.cue, this.prefilledTitle, super.key});

  final Cue? cue;
  final String? prefilledTitle;

  @override
  EditCueDialogState createState() => EditCueDialogState();
}

class EditCueDialogState extends State<EditCueDialog> {
  @override
  void initState() {
    _titleController = TextEditingController(text: widget.cue?.title ?? widget.prefilledTitle);
    _descriptionController = TextEditingController(
      text: widget.cue?.description,
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    onSubmit() async {
      if (_formKey.currentState!.validate()) {
        setState(() => isSaving = true);

        if (widget.cue != null) {
          updateCueMetadataFor(
            widget.cue!.id,
            title: _titleController.text,
            description: _descriptionController.text,
          );
          // ignore: use_build_context_synchronously
          context.pop();
        } else {
          final createdCue = await insertNewCue(
            title: _titleController.text,
            description: _descriptionController.text,
          );
          // ignore: use_build_context_synchronously
          context.pop<Cue>(createdCue);
        }
      }
    }

    return AlertDialog.adaptive(
      title:
          widget.cue != null
              ? Text('Lista szerkesztése')
              : Text('Lista létrehozása'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Cím'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kötelező címet adni a listának!';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => onSubmit(),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                decoration: InputDecoration(hintText: 'Leírás'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => context.pop(),
          child: Text('Mégse'),
        ),
        FilledButton(
          onPressed: onSubmit,
          child: AnimatedSize(
            duration: Durations.medium1,
            child:
                isSaving
                    ? SizedBox(width: 50, child: LinearProgressIndicator())
                    : Text(widget.cue != null ? 'Mentés' : 'Létrehozás'),
          ),
        ),
      ],
    );
  }
}

class DeleteCueDialog extends StatelessWidget {
  const DeleteCueDialog({super.key, required this.cue});

  final Cue cue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text('${cue.title} törlése - biztos vagy benne?'),
      actions: [
        TextButton.icon(
          label: Text(
            'Törlés',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          icon: IconTheme(
            data: IconThemeData(color: Colors.red),
            child: Icon(Icons.delete_forever),
          ),
          onPressed: () {
            deleteCueWithUuid(cue.uuid);
            context.pop();
          },
        ),
        FilledButton(onPressed: () => context.pop(), child: Text('Mégse')),
      ],
    );
  }
}
