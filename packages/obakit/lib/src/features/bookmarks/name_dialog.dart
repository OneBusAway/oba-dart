import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

/// Asks for a group name. Completes with the trimmed text, or null when
/// cancelled or blank. The dialog owns its text controller, so it is
/// disposed only after the dialog is gone.
Future<String?> showGroupNameDialog(
  BuildContext context, {
  required String title,
  String? initialName,
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (context) =>
        _GroupNameDialog(title: title, initialName: initialName),
  );
  final trimmed = name?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

class _GroupNameDialog extends StatefulWidget {
  const _GroupNameDialog({required this.title, this.initialName});

  final String title;
  final String? initialName;

  @override
  State<_GroupNameDialog> createState() => _GroupNameDialogState();
}

class _GroupNameDialogState extends State<_GroupNameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l10n.bookmarksEditorGroupName),
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l10n.bookmarksEditorSave),
        ),
      ],
    );
  }
}
