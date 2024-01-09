import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

AppointmentDataSource getCalendarDataSource(List<Appointment> eventList) {
  List<Appointment> appointments = <Appointment>[];

  appointments.add(Appointment(
      startTime: DateTime(2024, 1, 16, 10),
      endTime: DateTime(2024, 1, 20, 12),
      subject: 'Meeting',
      color: Colors.blue,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=10'));

  return AppointmentDataSource(appointments);
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}