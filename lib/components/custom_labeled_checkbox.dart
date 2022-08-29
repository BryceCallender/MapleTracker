import 'package:flutter/material.dart';

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
    this.checkboxType = CheckboxType.Child,
    this.activeColor,
  })  : assert(
          (checkboxType == CheckboxType.Child && value != null) ||
              checkboxType == CheckboxType.Parent,
        ),
        tristate = checkboxType == CheckboxType.Parent ? true : false;

  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final CheckboxType? checkboxType;
  final Color? activeColor;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return InkWell(
      onTap: _onChanged,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ExpansionTile(
                title: Text(label),
                controlAffinity: ListTileControlAffinity.leading,
                children: [
                  checkboxType == CheckboxType.Child
                      ? const SizedBox(width: 32)
                      : const SizedBox(width: 0),
                  Checkbox(
                    tristate: tristate,
                    value: value,
                    onChanged: (val) {
                      _onChanged();
                    },
                    activeColor: activeColor ?? themeData.toggleableActiveColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: themeData.textTheme.subtitle1,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChanged() {
    // if (value != null) {
    //   onChanged(!value);
    // } else {
    //   onChanged(value);
    // }
  }
}
