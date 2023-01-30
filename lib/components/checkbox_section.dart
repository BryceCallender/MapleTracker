import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/add_action_dialog.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class CheckboxSection extends StatelessWidget {
  const CheckboxSection(
      {Key? key,
      required this.label,
      required this.items,
      required this.type,
      this.canAdd})
      : super(key: key);

  final String label;
  final ActionType type;
  final List<Maple.Action> items;
  final bool? canAdd;

  @override
  Widget build(BuildContext context) {
    var accent = Theme.of(context).colorScheme.secondary;

    if (canAdd ?? false) {
      items.sort((a,b) => a.order.compareTo(b.order));
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: accent),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                textAlign: TextAlign.left,
              ),
              if (canAdd ?? false)
                IconButton(
                  onPressed: () => _dialogBuilder(context),
                  icon: Icon(Icons.add),
                )
              else
                SizedBox(height: 40,)
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 250,
            height: 250,
            child: Consumer<TrackerModel>(builder: (context, tracker, child) {
              return ListView(
                children: [
                  for (var item in items)
                    ContextMenuRegion(
                      contextMenu: GenericContextMenu(
                        buttonConfigs: [
                          ContextMenuButtonConfig(
                            "Edit",
                            icon: Icon(
                              Icons.edit,
                              size: 18,
                            ),
                            onPressed: () =>
                                _dialogBuilder(context, action: item),
                          ),
                          ContextMenuButtonConfig(
                            "Delete",
                            icon: Icon(
                              Icons.delete,
                              size: 18,
                            ),
                            onPressed: () {
                              tracker.removeAction(item);
                              context.showSnackBar(
                                message: '${item.name} was removed',
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    tracker.upsertAction(item);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      child: CustomLabeledCheckbox(
                        label: item.name,
                        value: item.done,
                        onChanged: (value) {
                          item.done = !item.done;
                          tracker.toggleAction(item);
                        },
                      ),
                    )
                ].animate(interval: 100.ms).fadeIn(duration: 200.ms).move(
                      begin: const Offset(-16, 0),
                      curve: Curves.easeOutQuad,
                    ),
              );
            }),
          )
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, {Maple.Action? action}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddActionDialog(
          action: action,
          actions: items,
          type: type,
        );
      },
    );
  }
}
