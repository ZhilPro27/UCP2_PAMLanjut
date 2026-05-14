import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Ya',
    this.cancelText = 'Batal',
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text(title),
      description: Text(message),
      actions: [
        ShadButton.outline(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        if (isDestructive)
          ShadButton.destructive(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm();
            },
            child: Text(confirmText),
          )
        else
          ShadButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm();
            },
            child: Text(confirmText),
          ),
      ],
    );
  }
}
