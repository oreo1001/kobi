import 'package:intl/intl.dart';

DateTime parseDateTime(String dateString) {
  // 정확한 날짜 형식을 지정합니다.
  const format = "EEE, dd MMM yyyy HH:mm:ss Z";
  try {
    // 날짜를 파싱합니다.
    final result = DateFormat(format).parse(dateString, true);
    return result;
  } catch (e) {
    // 파싱 중 오류가 발생하면 적절한 처리를 합니다.
    throw const FormatException("Invalid date format");
  }
}

String homeDateString(String dateString) {
  final DateFormat timeFormat = DateFormat('a h:mm', 'ko_KR');
  final DateFormat dateFormat = DateFormat('M월 d일');
  DateTime dateTime = DateTime.parse(dateString).toUtc();
  DateTime now = DateTime.now();

  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    // 오늘인 경우
    return timeFormat.format(dateTime);
  } else {
    // 이전인 경우
    return dateFormat.format(dateTime);
  }
}

String mailDateString(String dateString) {
  final DateFormat timeFormat = DateFormat('a h:mm');
  final DateFormat dateFormat = DateFormat('M월 d일');
  DateTime dateTime = parseDateTime(dateString);
  DateTime now = DateTime.now();

  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    // 오늘인 경우
    return timeFormat.format(dateTime);
  } else {
    // 이전인 경우
    return dateFormat.format(dateTime);
  }
}

String threadDateString(String dateString) {
  final DateFormat outputFormat = DateFormat('yyyy. MM. dd a h:mm');
  DateTime dateTime = parseDateTime(dateString);
  String formattedDate = outputFormat.format(dateTime);
  return formattedDate;
}