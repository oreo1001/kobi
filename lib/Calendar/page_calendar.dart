import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../theme.dart';
import 'methods/get_calendar_source.dart';
import 'methods/json_to_appointment.dart';
import 'widget_appointment_builder.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white70,
      ),
      body: FutureBuilder(
          future: getEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SfCalendar(
                  /// 정원 추가 ///
                  firstDayOfWeek: 1,
                  ///

                  initialSelectedDate: DateTime.now(),

                  onTap: (CalendarTapDetails details) {
                    print(details.appointments); /// TODO 이거 뭐지?
                  },

                  allowedViews: const <CalendarView>[
                    CalendarView.month,
                    // CalendarView.week,
                    // CalendarView.day,
                  ],

                  selectionDecoration: BoxDecoration(
                    color: const Color(0x88ACCCFF),
                    borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                    shape: BoxShape.rectangle,
                  ),

                  dataSource: getCalendarDataSource(snapshot.data!),

                  monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    agendaItemHeight: 70.h,
                    showTrailingAndLeadingDates: false,
                    dayFormat: 'EEE',
                  ),

                  timeSlotViewSettings: const TimeSlotViewSettings(
                      timelineAppointmentHeight: 100),

                  appointmentBuilder: appointmentBuilder,

                  view: CalendarView.month,

                  cellBorderColor: Colors.transparent,

                  headerDateFormat: 'yyyy년 MM월',

                  viewHeaderHeight: 40.h,

                  headerHeight: 50.h,

                  todayHighlightColor: const Color(0xff759CCC),

                  headerStyle: CalendarHeaderStyle(
                    textStyle: textTheme().displayMedium?.copyWith(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  ),

                  appointmentTimeTextFormat: 'HH:mm',

                  allowDragAndDrop: true

                // monthViewSettings: const MonthViewSettings(
                //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              );
            }
          }),
    );
  }
}