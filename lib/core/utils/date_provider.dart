import 'package:intl/intl.dart';

String covertDateToFormatted({required String date}){
  int timeStamp = int.parse(date);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
  return formattedDate;
}