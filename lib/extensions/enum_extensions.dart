import 'package:maple_daily_tracker/models/action-type.dart';

extension EnumExtension on ActionType {
  String toProperName() {
    final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    var parts = this.toString().split('.').last.split(beforeCapitalLetter);
    return parts.join(' ').toLowerCase();
  }
}