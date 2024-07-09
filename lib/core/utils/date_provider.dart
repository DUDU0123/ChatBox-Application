import 'package:intl/intl.dart';

String covertDateToFormatted({required String date}){
  int timeStamp = int.parse(date);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
  return formattedDate;
}

String take24HourTimeFromTimeStamp({required String timeStamp}){
  DateTime parsedDateTime = DateTime.parse(timeStamp);
  // Format the time to 24-hour format
  String formattedTime24 = DateFormat('HH:mm').format(parsedDateTime);
  return formattedTime24;
}
String take12HourTimeFromTimeStamp({required String timeStamp}){
  DateTime parsedDateTime = DateTime.parse(timeStamp);
  // Format the time to 12-hour format
  String formattedTime12 = DateFormat('hh:mm a').format(parsedDateTime);
  return formattedTime12;
}