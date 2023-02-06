import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:maple_daily_tracker/providers/theme_settings.dart';
import 'package:provider/provider.dart';

class PreferencesDialog extends StatefulWidget {
  const PreferencesDialog({Key? key}) : super(key: key);

  @override
  _PreferencesDialogState createState() => _PreferencesDialogState();
}

class _PreferencesDialogState extends State<PreferencesDialog> {
  late Color primary;
  late Color secondary;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final themeData = context.read<ThemeSettings>();
    primary = themeData.primary;
    secondary = themeData.secondary;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.50;
    var height = MediaQuery.of(context).size.height * 0.50;

    return AlertDialog(
      title: Text('Preferences'),
      content: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text('Primary Color'),
                  InkWell(
                    borderRadius: BorderRadius.circular(99.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () => pickColor(context, primary, (color) {
                      print(color);
                      setState(() {
                        primary = color;
                      });
                    }),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Secondary Color'),
                  InkWell(
                    borderRadius: BorderRadius.circular(99.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () => pickColor(context, secondary, (color) {
                      setState(() {
                        secondary = color;
                      });
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            context.read<ThemeSettings>().changeColors(primary, secondary);
            Navigator.of(context).pop();
          },
          child: Text('Apply'),
        )
      ],
    );
  }

  void pickColor(
          BuildContext context, Color base, Function(Color) onColorChanged) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pick a Color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlidePicker(
                pickerColor: base,
                onColorChanged: onColorChanged,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('SELECT'),
              )
            ],
          ),
        ),
      );
}
