import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../Class/class_my_event.dart';

String formatTime(String dateString) {
  DateTime utcDate = DateTime.parse(dateString).toUtc();
  DateTime date = utcDate.add(Duration(hours: 9));
  int hour = date.hour;
  int minute = date.minute;
  String period = hour >= 12 ? "오후" : "오전";
  hour = hour % 12;
  if (hour == 0) {
    hour = 12;
  }
  return '$period ${hour.toString()}:${minute.toString().padLeft(2, '0')}';
}
String getMonthAndDay(String dateString){
  if(dateString==''){
    return '미선택';
  }else{
    DateTime utcDate = DateTime.parse(dateString).toUtc();
    DateTime date = utcDate.add(Duration(hours: 9));
    String formatDay = DateFormat('M월 d일').format(date);
    return formatDay;
  }
}

DateTime combineDate(String dateString,String timeString){
  DateTime utcDate = DateTime.parse(dateString).toUtc();
  DateTime kstDate = utcDate.add(const Duration(hours: 9));
  DateTime utcTime = DateTime.parse(timeString).toUtc();
  DateTime kstTime = utcTime.add(const Duration(hours: 9));
  return DateTime(kstDate.year,kstDate.month,kstDate.day,kstTime.hour,kstTime.minute);
}

bool checkProperEndDate(String endDate){
  if(endDate ==''){
    Get.snackbar(
      "오류", // 제목
      "종료 시간을 선택해주세요!", // 메시지
      backgroundColor: Colors.grey,
      snackPosition: SnackPosition.TOP, // 스낵바 위치
    );
    return true;
  }return false;
}
bool checkIfEarlier(DateTime startTimeToBack, DateTime endTimeToBack){
  if(endTimeToBack.isBefore(startTimeToBack)){
    Get.snackbar(
      "오류", // 제목
      "종료 시간이 시작 시간보다 이전입니다!", // 메시지
      backgroundColor: Colors.grey,
      snackPosition: SnackPosition.TOP, // 스낵바 위치
    );
    return true;
  }return false;
}

MyEvent appointmentToMyEvent(Appointment appointment) {
  return MyEvent(
    summary: appointment.subject,
    startTime: appointment.startTime.toString(),
    endTime: appointment.endTime.toString(),
    description: appointment.notes,
    location: appointment.location,
    id: appointment.id.toString(),
    isAllDay: appointment.isAllDay,
  );
}

Appointment myEventToAppointment(MyEvent myEvent) {
  return Appointment(
    startTime: DateTime.parse(myEvent.startTime),
    endTime: DateTime.parse(myEvent.endTime),
    subject: myEvent.summary,
    id: myEvent.id, //eventId -> id
    location: myEvent.location,
    notes: myEvent.description,
    color: Colors.lightBlue, // 색상은 예시로 lightBlue
    isAllDay: myEvent.isAllDay,
  );
}