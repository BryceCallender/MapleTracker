import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
import 'package:maple_daily_tracker/models/character.dart';

class CheckBoxTree extends StatefulWidget {
  const CheckBoxTree({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CheckBoxTree> createState() => _CheckBoxTreeState();
}

class _CheckBoxTreeState extends State<CheckBoxTree> {
  bool? _value = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        children: [
          Text(
            widget.character.name,
          ),
          CustomLabeledCheckbox(
            label: "Dailies",
            value: _value,
            onChanged: (value) {},
          ),
          // ListView.builder(
          //   itemCount: widget.children.length,
          //   itemBuilder: (context, index) => CustomLabeledCheckbox(
          //     label: widget.children[index],
          //     value: widget.children[index],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildTree() {
  //
  // }

  void _checkAll(bool value) {

  }

  void _manageTriState(int index, bool value) {

  }
}
