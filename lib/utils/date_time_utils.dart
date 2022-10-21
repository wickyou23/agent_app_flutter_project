import 'package:intl/intl.dart';

const dateFormat = 'MM/dd/yyyy';
const dateTimeFormat = 'MM/dd/yyyy HH:mm:ss';

String? formatTime(DateTime date, {String format = dateTimeFormat}) {
  return formatDate(date, format: format);
}

String? formatDate(DateTime? date, {String format = dateFormat}) {
  if (date == null) return null;
  final formatter = DateFormat(format);
  return formatter.format(date.toLocal());
}

DateTime? parseDate(String strDate, String format, {bool utc = true}) {
  try {
    return DateFormat(format).parse(strDate, utc).toLocal();
  } catch (e) {
    return null;
  }
}

Duration getDurationBetweenDates(DateTime date1, DateTime date2) {
  return Duration(
      milliseconds:
          (date1.millisecondsSinceEpoch - date2.millisecondsSinceEpoch).abs());
}
