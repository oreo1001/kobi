import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

AppointmentDataSource getCalendarDataSource(List<Appointment> eventList) {
  return AppointmentDataSource(eventList);
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}