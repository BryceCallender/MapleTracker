import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';

class CheckBoxTree extends StatefulWidget {
  const CheckBoxTree({Key? key}) : super(key: key);

  @override
  State<CheckBoxTree> createState() => _CheckBoxTreeState();
}

class _CheckBoxTreeState extends State<CheckBoxTree> {
  @override
  Widget build(BuildContext context) {
    return CustomLabeledCheckbox(
      label: "Starcraft",
      checkboxType: CheckboxType.Parent,
      onChanged: (val) => {},
      value: null,
    );
  }
}
