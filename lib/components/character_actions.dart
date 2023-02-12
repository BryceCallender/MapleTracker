import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maple_daily_tracker/components/section.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class CharacterActions extends StatefulWidget {
  const CharacterActions(
      {Key? key, required this.characterId, required this.sections})
      : super(key: key);

  final int characterId;
  final Map<ActionType, ActionSection> sections;

  @override
  State<CharacterActions> createState() => _CharacterActionsState();
}

class _CharacterActionsState extends State<CharacterActions>
    with AutomaticKeepAliveClientMixin<CharacterActions> {
  Stream<List<Maple.Action>>? _actions;

  @override
  void initState() {
    super.initState();
    _actions = Provider.of<TrackerModel>(context, listen: false)
        .listenToActions(widget.characterId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return StreamBuilder<List<Maple.Action>>(
        stream: _actions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Section(
                  title: "Dailies",
                  characterId: widget.characterId,
                  section: widget.sections[ActionType.dailies]!,
                ),
                Section(
                  title: "Weekly Bosses",
                  characterId: widget.characterId,
                  section: widget.sections[ActionType.weeklyBoss]!,
                ),
                Section(
                  title: "Weekly Quests",
                  characterId: widget.characterId,
                  section: widget.sections[ActionType.weeklyQuest]!,
                ),
              ],
            );
          } else {
            return SizedBox(
              height: size.height / 1.5,
              child: Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                    color: Colors.blueAccent, size: size.height * 0.20),
              ),
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
