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

extension TitleCase on String {
  String toTitleCase() {
    return this.toLowerCase().replaceAllMapped(
        RegExp(
            r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
        (Match match) {
      return "${match[0]?[0].toUpperCase()}${match[0]?.substring(1).toLowerCase()}";
    }).replaceAll(RegExp(r'(_|-)+'), ' ');
  }
}
