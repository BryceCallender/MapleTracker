import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool? isTemp = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerModel>(
      builder: (context, tracker, child) {
        return AlertDialog(
          title: const Text('Add Action'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _actionName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }

                    //if (!tracker.isActionAvailable(value, widget.type)) {
                    //  return 'Name is already used';
                    //}

                    return null;
                  },
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
                if (_formKey.currentState!.validate()) {
                  var tracker = Provider.of<TrackerModel>(context, listen: false);
                  // tracker.addAction(
                  //   widget.type,
                  //   Maple.Action(name: _actionName.text, done: false),
                  // );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      }
    );
  }
}
