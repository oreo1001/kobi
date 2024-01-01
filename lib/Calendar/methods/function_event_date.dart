import 'package:intl/intl.dart';

String eventKSTDate(String exDate){
  DateTime utcDate = DateTime.parse(exDate).toUtc();
  DateTime kstDate = utcDate.add(Duration(hours: 9));
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(kstDate);
  return formattedDate;
}

String appointKSTDate(String exDate, bool isAllDay){
  DateTime kstDate;
  if(!isAllDay){
    DateTime utcDate = DateTime.parse(exDate).toUtc();
    kstDate = utcDate.add(Duration(hours: 9));
  }else {
    kstDate = DateTime.parse(exDate).toUtc();
  }
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(kstDate);
  return formattedDate;
}