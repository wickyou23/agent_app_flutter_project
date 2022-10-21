import 'package:agent_app/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime?, String?> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(String? strDate) {
    if (strDate == null) return null;
    return parseDate(strDate, "yyyy-MM-dd'T'HH:mm:ssZ");
  }

  @override
  String? toJson(DateTime? date) {
    if (date == null) return null;
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    return formatter.format(date.toUtc());
  }
}
