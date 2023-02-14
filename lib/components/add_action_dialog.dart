import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
import 'package:maple_daily_tracker/components/date_time_picker.dart';
import 'package:maple_daily_tracker/extensions/datetime_extensions.dart';
import 'package:maple_daily_tracker/extensions/enum_extensions.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class AddActionDialog extends StatefulWidget {
  const AddActionDialog(
      {Key? key, this.action, required this.actions, required this.type})
      : super(key: key);

  final Maple.Action? action;
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
  void initState() {
    super.initState();
    _actionName.text = widget.action?.name ?? '';
  }

  @override
  void dispose() {
    _actionName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.50;
    var height = MediaQuery.of(context).size.height * 0.50;

    return Consumer<TrackerModel>(builder: (context, tracker, child) {
      final title = widget.action == null ? 'Add Action' : 'Edit Action';
      return AlertDialog(
        title: Text(title),
        content: Container(
          width: width,
          height: height,
          child: Form(
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

                    if (widget.actions
                        .where((a) => a.name == value)
                        .isNotEmpty) {
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
                if (isTemp ?? false)
                  DateTimePicker(
                    onDateSelected: (dateTime) {
                      removalDateTime = dateTime;
                    },
                    onTimeSelected: (timeOfDay) {
                      var dateTime = removalDateTime ?? DateTime.now();
                      removalDateTime = dateTime.copyWith(
                          hour: timeOfDay.hour, minute: timeOfDay.minute);
                    },
                  ).animate().fadeIn()
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var tracker = Provider.of<TrackerModel>(context, listen: false);
                final action = widget.action;
                tracker.upsertActions(
                  [
                    Maple.Action(
                      id: action?.id ?? null,
                      actionType: widget.type,
                      name: _actionName.text.trim(),
                      done: action?.done ?? false,
                      order: action?.order ?? widget.actions.length,
                      createdOn: action?.createdOn ?? DateTime.now().toUtc(),
                      isTemp: isTemp ?? action?.isTemp,
                      removalTime: removalDateTime?.toUtc() ?? action?.removalTime,
                      characterId: action?.characterId ?? tracker.character.id!,
                    ),
                  ],
                );

                if (action != null) {
                  context.showSnackBar(message: 'Edited ${action.name}');
                } else {
                  context.showSnackBar(
                      message:
                          'Added ${_actionName.text} to ${widget.type.name}');
                }

                Navigator.of(context).pop();
              }
            },
            child: Text(widget.action == null ? 'Add' : 'Update'),
          )
        ],
      );
    });
  }
}
