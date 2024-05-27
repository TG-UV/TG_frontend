import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter() {
    initializeDateFormat();
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }

  String timeFormatedTextController(String timeString) {
    DateTime time = _parseTimeString(timeString);
    return DateFormat('hh:mm a', 'es_ES').format(time);
  }

  String timeFormatedToSend(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
  }

  String dayOfWeekFormated(String travelDate) {
    String dayOfWeekFormated = "";
    String dayOfWeek =
        DateFormat('EEEE', 'es_ES').format(DateTime.parse(travelDate));
    dayOfWeekFormated =
        "${dayOfWeek.substring(0, 1).toUpperCase()}${dayOfWeek.substring(1)}";
    return dayOfWeekFormated;
  }

  String dateFormatedToSend(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String dateFormatedTextController(DateTime date) {
    String dateFormated = DateFormat('EEEE, d MMMM', 'es_ES').format(date);
    return "${dateFormated.substring(0, 1).toUpperCase()}${dateFormated.substring(1)}";
  }

  String dateFormatedTextControllerComplete(DateTime date) {
    return DateFormat('d MMMM y', 'es_ES').format(date);
  }
}
