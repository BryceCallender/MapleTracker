import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/add_action_dialog.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/action.dart' as Maple;

class CheckboxSection extends StatelessWidget {
  const CheckboxSection(
      {Key? key,
      required this.label,
      required this.items,
      this.canAdd,
      required this.type})
      : super(key: key);

  final String label;
  final ActionType type;
  final List<Maple.Action> items;
  final bool? canAdd;

  @override
  Widget build(BuildContext context) {
    var accent = Theme.of(context).colorScheme.secondary;
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: accent),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                textAlign: TextAlign.left,
              ),
              IconButton(
                onPressed: () => _dialogBuilder(context),
                icon: Icon(Icons.add),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 250,
            height: 250,
            child: Consumer<TrackerModel>(
              builder: (context, tracker, child) {
                return ListView(
                  children: [
                    for (var item in items)
                      CustomLabeledCheckbox(
                        label: item.name,
                        value: item.done,
                        onChanged: (value) {
                          item.done = !item.done;
                          tracker.updateAction(type, item);
                        },
                      )
                  ]
                      .animate(interval: 100.ms)
                      .fadeIn(duration: 200.ms)
                      .move(
                        begin: const Offset(-16, 0),
                        curve: Curves.easeOutQuad,
                      ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AddActionDialog(
            type: type,
          );
        });
  }
}
