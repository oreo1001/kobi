import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../function_http_request.dart';
import 'function_event_date.dart';

List<Appointment> loadAppointmentsFromJson(List<dynamic> jsonList) {
  var newAppointments = jsonList.map((json) {
    bool isAllDay = json['isAllDay'];
    return Appointment(
      startTime: DateTime.parse(appointKSTDate(json['startTime'], isAllDay)),
      endTime: DateTime.parse(appointKSTDate(json['endTime'], isAllDay)),
      subject: json['summary'] ?? '',
      isAllDay: json['isAllDay'],
      notes: json['description'],
      location: json['location'],
      color : json['color'] ?? Colors.lightBlue, /// TODO json에서는 Color 객체를 전달받을 수 없습니다..
    );
  }).toList();
  return newAppointments;
}

Future<List<Appointment>> getEvents() async {
  Map<String, dynamic> responseMap = await httpResponse('/calendar/eventList', {});
  List<Appointment> eventList = [];

  for (Map data in responseMap['data']) {
    if (data['summary'] == 'primary' ||
        data['summary'] == 'WonMoCalendar') {
      eventList.addAll(loadAppointmentsFromJson(data['eventList']));
    }
  }
  return eventList;
}