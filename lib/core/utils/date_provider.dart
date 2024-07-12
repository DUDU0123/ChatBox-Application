import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  static String formatMessageDateTime({required String messageDateTimeString}) {
    DateTime messageDateTime = DateTime.parse(messageDateTimeString);
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (messageDateTime.day == now.day &&
        messageDateTime.month == now.month &&
        messageDateTime.year == now.year) {
      // Today
      return DateFormat.Hm()
          .format(messageDateTime); // 24-hour time format (e.g., 10:00)
    } else if (messageDateTime.day == yesterday.day &&
        messageDateTime.month == yesterday.month &&
        messageDateTime.year == yesterday.year) {
      // Yesterday
      return "Yesterday";
    } else {
      // Earlier days
      return DateFormat("MMM dd yyyy")
          .format(messageDateTime); // e.g., Apr 10 2024
    }
  }
}

class TimeProvider {
  static String formatDuration(Duration? duration) {
    if (duration == null) return '0:00';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  static String getUserLastActiveTime({
    required String givenTime,
    required BuildContext context,
  }) {
    final int i = int.tryParse(givenTime) ?? -1;
    if (i == 1) return "Last seen not available";
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return "Last seen today at $formattedTime";
    }

    if (now.difference(time).inHours / 24.round() == 1) {
      return "Last seen yesterday at $formattedTime";
    }
    String month = getMonth(date: time);
    return "Last seen on ${time.day} $month on ";
  }

  static String getMonth({required DateTime date}) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return 'Not available';
    }
  }
}
