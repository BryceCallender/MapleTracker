import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/extensions/color_extensions.dart';

enum CheckboxType {
  Parent,
  Child,
}

class CustomLabeledCheckbox extends StatelessWidget {
  const CustomLabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.checkboxType = CheckboxType.Parent,
    this.activeColor,
  })  : assert(
          (checkboxType == CheckboxType.Child && value != null) ||
              checkboxType == CheckboxType.Parent,
        ),
        tristate = checkboxType == CheckboxType.Parent;

  final String label;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final CheckboxType? checkboxType;
  final Color? activeColor;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: _onChanged,
      child: Row(
        children: <Widget>[
          checkboxType == CheckboxType.Child
              ? SizedBox(width: 48)
              : SizedBox(width: 0),
          Checkbox(
            tristate: tristate,
            value: value,
            onChanged: (val) => _onChanged(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: themeData.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  void _onChanged() {
    if (value != null) {
      onChanged(!(value!));
    } else {
      onChanged(value);
    }
  }
}
