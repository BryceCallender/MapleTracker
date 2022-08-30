import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Starcraft"),
        Row(
          children: [
            ActionChip(
              avatar: stateToIcon(false),
              label: Text("Dailies"),
              onPressed: () {},
            ),
            const SizedBox(
              width: 4.0,
            ),
            ActionChip(
              avatar: stateToIcon(false),
              label: Text("Weeklies"),
              onPressed: () {},
            ),
            const SizedBox(
              width: 4.0,
            ),
            ActionChip(
              avatar: stateToIcon(false),
              label: Text("Mon Weeklies"),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Icon stateToIcon (bool isHidden) {
    IconData data = isHidden ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill;
    return Icon(data);
  }
}
