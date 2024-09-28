import 'package:intl/intl.dart';

class DateFormatUtils {
  static String parseDate(DateTime date) {
    return "${DateFormat.Md().format(date)}\n${date.year}";
  }

  static String parseTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}
