import 'package:intl/intl.dart';

class DateProvider {
  static String covertDateToFormatted({required String date}) {
    int timeStamp = int.parse(date);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    return formattedDate;
  }

  static String take24HourTimeFromTimeStamp({required String timeStamp}) {
    DateTime parsedDateTime = DateTime.parse(timeStamp);
    // Format the time to 24-hour format
    String formattedTime24 = DateFormat('HH:mm').format(parsedDateTime);
    return formattedTime24;
  }

  static String take12HourTimeFromTimeStamp({required String timeStamp}) {
    DateTime parsedDateTime = DateTime.parse(timeStamp);
    // Format the time to 12-hour format
    String formattedTime12 = DateFormat('hh:mm a').format(parsedDateTime);
    return formattedTime12;
  }

  static String parseDuration(String input) {
    List<String> parts = input.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    List<String> secondsParts = parts[2].split('.');
    int seconds = int.parse(secondsParts[0]);
    Duration duration =
        Duration(hours: hours, minutes: minutes, seconds: seconds);
    int totalMinutes = duration.inMinutes;
    int sec = duration.inSeconds % 60;
    String minutesStr = totalMinutes.toString();
    String secondsStr = sec.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
}
