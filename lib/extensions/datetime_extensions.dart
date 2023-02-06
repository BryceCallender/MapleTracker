import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime.utc(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime zeroOutTime() {
    return DateTime.utc(
        year,
        month,
        day,
        0,
        0,
        0,
        0,
        0
    );
  }

  static DateTime? parseQtTime(String qtTime) {
    if (qtTime.isEmpty) {
      return null;
    }

    return DateFormat("EEE MMM d HH:mm:ss y").parse(qtTime);
  }
}