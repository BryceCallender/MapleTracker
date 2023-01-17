import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
import 'package:maple_daily_tracker/components/date_time_picker.dart';
import 'package:maple_daily_tracker/extensions/datetime_extensions.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class AddActionDialog extends StatefulWidget {
  const AddActionDialog({Key? key, required this.actions, required this.type})
      : super(key: key);

  final List<Maple.Action> actions;
  final ActionType type;

  @override
  State<AddActionDialog> createState() => _AddActionDialogState();
}

class _AddActionDialogState extends State<AddActionDialog> {
  TextEditingController _actionName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? isTemp = false;
  DateTime? removalDateTime;

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerModel>(builder: (context, tracker, child) {
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

                  if (widget.actions.where((a) => a.name == value).isNotEmpty) {
                    return 'Name is already used';
                  }

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
              if (isTemp ?? false) DateTimePicker(
                onDateSelected: (dateTime) {
                  removalDateTime = dateTime;
                },
                onTimeSelected: (timeOfDay) {
                  var dateTime = removalDateTime ?? DateTime.now();
                  removalDateTime = dateTime.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
                },
              ).animate().fadeIn()
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
                tracker.addAction(
                  Maple.Action(
                    id: null,
                    actionType: widget.type,
                    name: _actionName.text,
                    done: false,
                    order: widget.actions.length,
                    createdOn: DateTime.now().toUtc(),
                    isTemp: isTemp,
                    removalTime: removalDateTime,
                    characterId: tracker.character.id,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          )
        ],
      );
    });
  }
}
