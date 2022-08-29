import 'package:flutter/material.dart';

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
              avatar: Icon(Icons.remove_red_eye_rounded),
              label: Text("Dailies"),
              onPressed: () {},
            ),
            const SizedBox(
              width: 4.0,
            ),
            ActionChip(
              label: Text("Weeklies"),
              onPressed: () {},
            ),
            const SizedBox(
              width: 4.0,
            ),
            ActionChip(
              label: Text("Mon Weeklies"),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
