import 'package:intl/intl.dart' as intl;

extension DateTimeExt on DateTime {
  String csToString(String formatString) {
    final format = intl.DateFormat(formatString);
    return format.format(this);
  }

  DateTime startOfDate() {
    return DateTime(year, month, day);
  }

  DateTime endOfDate() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  bool isToday() {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.year == year &&
        tomorrow.month == month &&
        tomorrow.day == day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day;
  }

  //Start at Monday
  static List<DateTime> dateInWeekByDate(DateTime date) {
    final now = DateTime.now().startOfDate();
    final weekDay = date.weekday;
    final result = <DateTime>[];
    for (var i = 1; i <= 7; i++) {
      final calculate = now.add(Duration(days: i - weekDay));
      result.add(calculate);
    }

    return result;
  }
}
