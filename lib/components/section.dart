import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/checkbox_section.dart';
import 'package:maple_daily_tracker/components/reorder_action_dialog.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class Section extends StatefulWidget {
  const Section({Key? key, required this.title, required this.characterId, required this.section})
      : super(key: key);

  final String title;
  final int characterId;
  final ActionSection section;

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Consumer<TrackerModel>(
      builder: (context, tracker, child) {
        return trackerCard(textTheme, tracker);
      },
    );
  }

  Widget trackerCard(TextTheme textTheme, TrackerModel tracker) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      tracker.toggleSection(widget.characterId, widget.section.actionType);
                    },
                    icon: widget.section.isActive
                        ? Icon(CupertinoIcons.eye_fill)
                        : Icon(CupertinoIcons.eye_slash_fill),
                ),
                Text(
                  widget.title,
                  style: textTheme.bodyLarge,
                ),
                Spacer(),
                if (widget.section.actionList.isNotEmpty)
                  IconButton(
                    onPressed: () => _showReorderActionDialog(context),
                    icon: Icon(CupertinoIcons.list_number),
                  ),
              ],
            ),
            Visibility(
              visible: widget.section.isActive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CheckboxSection(
                    label: "Unfinished",
                    type: widget.section.actionType,
                    canAdd: true,
                    items: widget.section.actionList.where((a) => !a.done).toList(),
                  ),
                  CheckboxSection(
                    label: "Finished",
                    type: widget.section.actionType,
                    items: widget.section.actionList.where((a) => a.done).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReorderActionDialog(
      BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ReorderActionDialog(
          actions: widget.section.actionList,
        );
      },
    );
  }
}
