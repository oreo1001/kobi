import 'package:intl/intl.dart';

DateTime dateStrToKSTDate(String exDate){
  DateTime utcDate = DateTime.parse(exDate).toUtc();
  DateTime kstDate = utcDate.add(Duration(hours: 9));
  return kstDate;
}

String appointKSTDate(String exDate){
  DateTime utcDate = DateTime.parse(exDate).toUtc();
  DateTime kstDate = utcDate.add(Duration(hours: 9));
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(kstDate);
  return formattedDate;
}
String appointKSTEndDate(String endDate){
  DateTime utcDate = DateTime.parse(endDate).toUtc();
  DateTime kstDate = utcDate.add(Duration(hours: 9));
  if(kstDate.hour == 0  && kstDate.minute ==0){
    kstDate = kstDate.subtract(const Duration(minutes: 1));
  }
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(kstDate);
  return formattedDate;
}

bool checkIfSameDay(DateTime startDate, DateTime endDate){
  if(startDate.day == endDate.day){
    return true;
  }else {
    return false;
  }
}