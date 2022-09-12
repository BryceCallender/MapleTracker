import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';

import '../models/action.dart' as Maple;
import '../models/action-type.dart';
import 'custom_labeled_checkbox.dart';
import 'date_time_picker.dart';

class AddActionDialog extends StatefulWidget {
  const AddActionDialog({Key? key, required this.type}) : super(key: key);

  final ActionType type;

  @override
  State<AddActionDialog> createState() => _AddActionDialogState();
}

class _AddActionDialogState extends State<AddActionDialog> {
  TextEditingController _actionName = TextEditingController();
  bool? isTemp = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Action'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _actionName,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 8.0),
          CustomLabeledCheckbox(
            label: "Temporary",
            value: isTemp,
            onChanged: (value) {
              setState(() {
                isTemp = value;
              });
            },
          ),
          SizedBox(
            height: 8.0,
          ),
          if (isTemp ?? false) DateTimePicker().animate().fadeIn()
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            var tracker = Provider.of<TrackerModel>(context, listen: false);
            tracker.addAction(
              widget.type,
              Maple.Action(name: _actionName.text, done: false),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}
