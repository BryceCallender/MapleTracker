import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/character.dart';

class TrackerModel extends ChangeNotifier {
  final List<Character> _characters = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Character> get characters => UnmodifiableListView(_characters);

  void add(Character character) {
    _characters.add(character);
    notifyListeners();
  }

  void remove(Character character) {
    _characters.remove(character);
    notifyListeners();
  }
}