import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/maple-class.dart';
import 'package:maple_daily_tracker/models/old-maple-tracker.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class ImportCharactersDialog extends StatefulWidget {
  const ImportCharactersDialog({Key? key, required this.tracker})
      : super(key: key);

  final MapleTracker tracker;

  @override
  _ImportCharactersDialogState createState() => _ImportCharactersDialogState();
}

class _ImportCharactersDialogState extends State<ImportCharactersDialog> {
  final List<TextEditingController> mapleClassControllers = [];
  List<MapleClass> sortedClassTypes = [];
  MapleClass classType = MapleClass.None;
  late List<MapleClass> selectedClasses;

  @override
  void initState() {
    super.initState();
    sortedClassTypes = List.from(MapleClass.values);
    sortedClassTypes.sort((MapleClass a, MapleClass b) {
      return a.name.compareTo(b.name);
    });

    sortedClassTypes.remove(MapleClass.None);
    sortedClassTypes.insert(0, MapleClass.None);

    selectedClasses = [];
    widget.tracker.characters.forEach((character) {
      selectedClasses.add(MapleClass.None);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.50;
    var height = MediaQuery.of(context).size.height * 0.50;

    _row(int index) {
      final character = widget.tracker.characters[index];
      final controller = TextEditingController();
      mapleClassControllers.add(controller);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(character.name),
          const SizedBox(
            width: 8.0,
          ),
          DropdownMenu<MapleClass>(
            initialSelection: MapleClass.None,
            controller: controller,
            label: const Text('Class'),
            dropdownMenuEntries: sortedClassTypes
                .map(
                  (value) => DropdownMenuEntry<MapleClass>(
                    value: value,
                    label: value.name,
                  ),
                )
                .toList(),
            onSelected: (MapleClass? pickedClass) {
              setState(() {
                selectedClasses[index] = pickedClass!;
              });
            },
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Import Character'),
      content: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: widget.tracker.characters.length,
                itemBuilder: (context, index) => _row(index),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 16.0,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                const SizedBox(width: 8.0,),
                FilledButton(
                  child: Text("Import!"),
                  onPressed: () {
                    context
                        .read<TrackerModel>()
                        .importFromOldSave(widget.tracker, selectedClasses);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
