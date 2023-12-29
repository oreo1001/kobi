import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../function_http_request.dart';
import '../theme.dart';
import 'function_event_date.dart';
import 'widget_appointment_builder.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool isPrimaryChecked = true;
  bool isWonMoChecked = true;

  Future<List<Appointment>> getEvents() async {
    Map<String, dynamic> responseMap = await httpResponse('/calendar/eventList', {});
    List<Appointment> eventList = [];

    for (Map data in responseMap['data']) {
      if ((isPrimaryChecked && data['summary'] == 'primary') ||
          (isWonMoChecked && data['summary'] == 'WonMoCalendar')) {
        eventList.addAll(loadAppointmentsFromJson(data['eventList']));
      }
    }
    return eventList;
  }
  List<Appointment> loadAppointmentsFromJson(List<dynamic> jsonList) {
    var newAppointments = jsonList.map((json) {
      bool isAllDay = json['isAllDay'];
      return Appointment(
        startTime: DateTime.parse(appointKSTDate(json['startTime'], isAllDay)),
        endTime: DateTime.parse(appointKSTDate(json['endTime'], isAllDay)),
        subject: json['summary'] ?? '',
        isAllDay: isAllDay,
        notes: json['description'],
        location: json['location'],
        color : json['color'] ?? Colors.lightBlue,
      );
    }).toList();
    return newAppointments;
  }
    Future<List<Appointment>>? futureEvents;
  void filterEvents() {
    setState(() {
      futureEvents = getEvents();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureEvents ??= getEvents();     //futureEvents null
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        // toolbarHeight: 70.h,
        title :Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('내 캘린더',style: textTheme().displaySmall?.copyWith(fontSize: 10.sp),),
                Transform.scale(
                  scale:0.6,
                  child: Checkbox(
                    value: isPrimaryChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isPrimaryChecked = value!;
                        filterEvents();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('wonmo 캘린더',style: textTheme().displaySmall?.copyWith(fontSize: 10.sp),),
                Transform.scale(
                  scale:0.6,
                  child: Checkbox(
                    value: isWonMoChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isWonMoChecked = value!;
                        filterEvents();
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),),
      body: FutureBuilder<List<Appointment>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SfCalendar(
                  initialSelectedDate: DateTime.now(),
                  onTap: (CalendarTapDetails details) {
                    print(details.appointments);
                    // dynamic appointment = details.appointments;
                    // DateTime date = details.date!;
                    // CalendarElement element = details.targetElement;
                  },
                  onViewChanged: (ViewChangedDetails details) {
                    List<DateTime> dates = details.visibleDates;
                  },
                  allowedViews: const <CalendarView>[
                    CalendarView.month,
                    // CalendarView.week,
                    // CalendarView.day,
                  ],
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: const Color(0xff8B2CF5), width: 2.w),
                    // borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                    // shape: BoxShape.rectangle,
                  ),
                  dataSource: _getCalendarDataSource(snapshot.data!),
                  monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    agendaItemHeight: 70.h,
                    showTrailingAndLeadingDates: false,
                    dayFormat: 'EEE',
                    //appointmentDisplayMode: MonthAppointmentDisplayMode.appointment, //agenda 없을때 이거로
                    // agendaViewHeight: 200.h,
                  ),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                      timelineAppointmentHeight: 100),
                  appointmentBuilder: appointmentBuilder,
                  view: CalendarView.month,
                  cellBorderColor: Colors.transparent,
                  // timeZone: 'Korea Standard Time', 이미 시간을 KST로바꿔서 넣기때문에 이걸로 조정한다.
                  headerDateFormat: 'yyyy년 MM월',
                  viewHeaderHeight: 40.h,
                  headerHeight: 50.h,
                  todayHighlightColor: const Color(0xff8B2CF5),
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

_AppointmentDataSource _getCalendarDataSource(List<Appointment> eventList) {
  List<Appointment> appointments = <Appointment>[];
  DateTime date = DateTime.now();
  appointments.addAll(eventList); //List<String,String>
  // appointments.add(Appointment(
  //   startTime: DateTime(
  //     date.year,
  //     date.month+1,
  //     5,
  //     9,
  //     0,
  //     0,
  //   ),
  //   endTime: DateTime(date.year, date.month+1, 6, 14, 0, 0),
  //   subject: '김정모대표와 미팅을 하고 싶다아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아',
  //   color: Colors.lightBlue,
  //   notes: 'hhhhhhhh',
  // ));
  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}