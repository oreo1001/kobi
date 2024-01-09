import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/ResponseWidgets/delete_event.dart';
import 'package:kobi/Assistant/ResponseWidgets/describe_user_query.dart';
import 'package:kobi/Dialog/page_auto_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Assistant/ResponseWidgets/create_email.dart';
import '../Assistant/ResponseWidgets/insert_event.dart';
import '../Assistant/ResponseWidgets/patch_event.dart';
import '../in_app_notification/in_app_notification.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String sendMailAddress = 'careebee@wonmo.net';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: _getCalendarDataSource(),
            monthViewSettings: MonthViewSettings(
              showAgenda: true,
              agendaItemHeight: 70.h,
              showTrailingAndLeadingDates: false,
              dayFormat: 'E',
            ),
            onTap: (CalendarTapDetails details) {
              // if (details.appointments!.isNotEmpty &&
              //     details.appointments != null) {
              //   final dynamic occurrenceAppointment = details.appointments![0];
              //   final Appointment? patternAppointment =
              //   dataSource.getPatternAppointment(occurrenceAppointment, '')
              //   as Appointment?;
              //   print(patternAppointment);
              // }
            },
          ),
        ),
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    appointments.add(Appointment(
        startTime: DateTime(2024, 1, 1, 10),
        endTime: DateTime(2024, 1, 16, 12),
        subject: 'Meeting',
        color: Colors.blue,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=3;COUNT=1;'));

    List<DateTime> dateCollection = SfCalendar.getRecurrenceDateTimeCollection(
        'FREQ=DAILY;INTERVAL=2;COUNT=3',DateTime(2024, 1, 1, 10));
    appointments.add(Appointment(
        startTime: DateTime(2019, 12, 16, 10),
        endTime: DateTime(2019, 12, 16, 12),
        subject: 'Occurs daily',
        color: Colors.red,
        // recurrenceRule: 'FREQ=DAILY;COUNT=20',
        recurrenceExceptionDates: dateCollection));

    return _AppointmentDataSource(appointments);
  }
}
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}