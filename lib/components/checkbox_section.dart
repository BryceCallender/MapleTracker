import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';

import '../models/action.dart' as Maple;

class CheckboxSection extends StatelessWidget {
  const CheckboxSection({Key? key, required this.label, required this.items})
      : super(key: key);

  final String label;
  final List<Maple.Action> items;

  @override
  Widget build(BuildContext context) {
    var accent = Theme.of(context).colorScheme.secondary;
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: accent),
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.0,),
          SizedBox(
            width: 250,
            height: 250,
            child: ListView(
              children: [
                for (var item in items)
                  CustomLabeledCheckbox(
                    label: item.name,
                    value: item.done,
                    onChanged: (value) {
                      item.done = value!;
                    },
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
