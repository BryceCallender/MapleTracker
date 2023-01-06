import 'package:flutter/material.dart';

import 'custom_labeled_checkbox.dart';

class ParentChildCheckboxes extends StatefulWidget {
  @override
  _ParentChildCheckboxesState createState() => _ParentChildCheckboxesState();
}

class _ParentChildCheckboxesState extends State<ParentChildCheckboxes> {
  late bool? _parentValue;
  late List<String> _children;
  late List<bool> _childrenValue;

  void _manageTristate(int index, bool? value) {
    setState(() {
      if (value != null) {
        // selected
        _childrenValue[index] = true;
        // Checking if all other children are also selected -
        if (_childrenValue.contains(false)) {
          // No. Parent -> tristate.
          _parentValue = null;
        } else {
          // Yes. Select all.
          _checkAll(true);
        }
      } else {
        // unselected
        _childrenValue[index] = false;
        // Checking if all other children are also unselected -
        if (_childrenValue.contains(true)) {
          // No. Parent -> tristate.
          _parentValue = null;
        } else {
          // Yes. Unselect all.
          _checkAll(false);
        }
      }
    });
  }

  void _checkAll(bool value) {
    setState(() {
      _parentValue = value;

      for (int i = 0; i < _children.length; i++) {
        _childrenValue[i] = value;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _parentValue = false;

    _children = [
      'Pickles',
      'Tomato',
      'Lettuce',
      'Cheese',
    ];

    /*
    * There are four children, so there should be a list of 4 bool values to
    * manage their states. This generates and assigns the
    * _childrenValue = [false, false, false, false].
    * */
    _childrenValue = List.generate(_children.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(themeData),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Parent-Child Checkboxes'),
      centerTitle: false,
    );
  }

  Widget _buildBody(ThemeData themeData) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 16, 12),
          child: Text(
            'Meal options',
          ),
        ),
        CustomLabeledCheckbox(
          label: 'Additions',
          value: _parentValue,
          onChanged: (value) {
            if (value != null) {
              // Checked/Unchecked
              _checkAll(value);
            } else {
              // Tristate
              _checkAll(true);
            }
          },
          checkboxType: CheckboxType.Parent,
        ),
        ListView.builder(
          itemCount: _children.length,
          itemBuilder: (context, index) => CustomLabeledCheckbox(
            label: _children[index],
            value: _childrenValue[index],
            onChanged: (value) {
              _manageTristate(index, value);
            },
            checkboxType: CheckboxType.Child,
          ),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
      ],
    );
  }
}