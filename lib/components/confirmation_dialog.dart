import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key, required this.onAccept, required this.onReject, required this.removalText}) : super(key: key);

  final String removalText;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: Text('Are you sure you want to remove $removalText'),
      actions: [
        TextButton(
            onPressed: () {
              onReject();
              Navigator.of(context).pop();
            },
            child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            onAccept();
            Navigator.of(context).pop();
          },
          child: const Text('Yes'),
        )
      ],
    );
  }
}
