import 'package:intl/intl.dart';

DateTime changeStrToDate(String originalDateStr) {
  String originalDateStr = "2023년 12월 7일 (목) 오전 1:07";

  // '년', '월', '일', '(', ')', '오전' 등을 제거하고 날짜와 시간 부분만 추출
  String yearStr = originalDateStr.split(' ')[0].replaceAll('년', '');
  String monthStr = originalDateStr.split(' ')[1].replaceAll('월', '').padLeft(2, '0');  // 월을 두 자리수로 표현
  String dayStr = originalDateStr.split(' ')[2].replaceAll('일', '').padLeft(2, '0');  // 일을 두 자리수로 표현
  String timeStr = originalDateStr.split(' ')[5];

  // 시간을 두 자리수로 표현
  String hourStr = timeStr.split(':')[0].padLeft(2, '0');
  String minStr = timeStr.split(':')[1];

  // 오전 12시는 00시로 변환
  if (originalDateStr.contains('오전') && hourStr == '12') {
    hourStr = '00';
  }
  // 오후 시간은 12를 더해서 24시간 형식으로 변환 (단, 12시는 그대로 유지)
  else if (originalDateStr.contains('오후') && hourStr != '12') {
    int hour = int.parse(hourStr) + 12;
    hourStr = hour.toString().padLeft(2, '0');
  }

  // 'yyyy-MM-dd HH:mm' 형식의 문자열로 변환
  String formattedDateStr = '$yearStr-$monthStr-$dayStr $hourStr:$minStr';

  // DateTime 객체로 변환
  DateTime dateTime = DateTime.parse(formattedDateStr);
  return dateTime;
}

String mailDateString(String dateString) {
  final DateFormat timeFormat = DateFormat('a h:mm');
  final DateFormat dateFormat = DateFormat('M월 d일');
  //DateFormat inputFormat = DateFormat('E, d MMM yyyy HH:mm:ss Z');
  // DateTime dateTime = inputFormat.parse(dateString).toUtc();\
  DateTime dateTime = changeStrToDate(dateString);
  DateTime kstDate = dateTime.add(const Duration(hours: 9));
  DateTime now = DateTime.now();

  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    // 오늘인 경우
    return timeFormat.format(kstDate);
  } else {
    // 이전인 경우
    return dateFormat.format(kstDate);
  }
}

String threadDateString(String dateString) {
  final DateFormat outputFormat = DateFormat('yyyy. MM. dd a h:mm');
  DateTime dateTime = changeStrToDate(dateString);
  String formattedDate = outputFormat.format(dateTime);
  return formattedDate;
}