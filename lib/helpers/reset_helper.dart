import 'package:maple_daily_tracker/extensions/datetime_extensions.dart';

class ResetHelper {
  Duration calcResetTime({int days = 1}) {
    var utcNow = DateTime.now().toUtc();
    var resetDate = utcNow.add(Duration(days: days));

    resetDate = resetDate.zeroOutTime();
    return resetDate.difference(utcNow);
  }

  Duration calcWeeklyResetTime({int resetDay = DateTime.thursday}) {
    int days = daysTillWeekly(resetDay);
    return calcResetTime(days: days);
  }

  int daysTillWeekly(int resetDay) {
    var utcNow = DateTime.now().toUtc();
    var dayOfWeek = utcNow.weekday;

    var distanceInDays = (resetDay - dayOfWeek).abs();

    if (dayOfWeek >= resetDay) {
      return DateTime.sunday - distanceInDays;
    }

    return distanceInDays;
  }
}
