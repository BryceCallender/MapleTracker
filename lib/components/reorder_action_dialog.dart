import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:collection/collection.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class ReorderActionDialog extends StatefulWidget {
  const ReorderActionDialog({Key? key, required this.actions})
      : super(key: key);

  final List<Maple.Action> actions;

  @override
  _ReorderActionDialogState createState() => _ReorderActionDialogState();
}

class _ReorderActionDialogState extends State<ReorderActionDialog> {
  @override
  void initState() {
    super.initState();
    widget.actions.sort((a,b) => a.order.compareTo(b.order));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.50;
    var height = MediaQuery.of(context).size.height * 0.50;

    return AlertDialog(
      title: const Text('Reorder Actions'),
      content: Container(
        height: height,
        width: width,
        child: ReorderableListView(
          children: widget.actions
              .mapIndexed(
                (index, a) => ReorderableDragStartListener(
                  key: Key('$index'),
                  index: index,
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    leading: Text('${index + 1}.'),
                    title: Text(a.name),
                  ),
                ),
              )
              .toList(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Maple.Action item = widget.actions.removeAt(oldIndex);
              widget.actions.insert(newIndex, item);
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            // upsert actions to db
            List<Maple.Action> orderedActions = [];
            widget.actions.forEachIndexed((index, action) {
              orderedActions.add(action.copyWith(order: index));
            });
            context.read<TrackerModel>().upsertActions(orderedActions);
            Navigator.of(context).pop();
          },
          child: const Text('Finish'),
        )
      ],
    );
  }
}
