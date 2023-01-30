import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/maple-class.dart';

extension ActionExtension on ActionType {
  String get name {
    final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    var parts = this.toString().split('.').last.split(beforeCapitalLetter);
    return parts.join(' ').toLowerCase();
  }
}

extension ClassExtension on MapleClass {
  String get name {
    final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    var parts = this.toString().split('.').last.split(beforeCapitalLetter);
    return parts.join(' ');
  }
}