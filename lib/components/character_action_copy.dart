import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/parent_child_checkboxes_state.dart';
import 'package:parent_child_checkbox/parent_child_checkbox.dart';

class CharacterActionCopy extends StatefulWidget {
  const CharacterActionCopy({Key? key}) : super(key: key);

  @override
  _CharacterActionCopyState createState() => _CharacterActionCopyState();
}

class _CharacterActionCopyState extends State<CharacterActionCopy> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ParentChildCheckbox(
          parent: Text('Dailies'),
          children: [
            Text('Test'),
            Text('Test2')
          ],
        ),
        ParentChildCheckbox(
          parent: Text('Weekly Bosses'),
          children: [
            Text('Test')
          ],
        ),
        ParentChildCheckbox(
          parent: Text('Weekly Quest'),
          children: [
            Text('Test')
          ],
        ),
      ],
    );
  }
}
