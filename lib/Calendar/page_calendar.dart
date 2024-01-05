import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:kobi/Calendar/widget/widget_appointment_builder.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../theme.dart';
import 'widget/appointment_sheet.dart';
import 'methods/get_calendar_source.dart';
import 'methods/json_to_appointment.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  DateTime _selectedDate = DateTime.now();
  Rx<DateTime> tempDate = DateTime.now().obs;
  RxString _headerText = ''.obs;

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    _headerText.value = DateFormat('yyyy년 M월').format(now);
  }

  @override
  Widget build(BuildContext context) {
    _calendarController.displayDate = _selectedDate; //달력 보여주는 날짜
    _calendarController.selectedDate = _selectedDate; //달력에서 선택된 날짜
    _headerText.value = DateFormat('yyyy년 M월').format(_selectedDate); //2023년 12월
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: <Widget>[
                TextButton(
                    style:
                        TextButton.styleFrom(foregroundColor: Colors.black87),
                    onPressed: () {
                      _showTimeScroller(context);
                    },
                    child: Row(
                      children: [
                        Obx(()=>Text(_headerText.value,
                            style: textTheme()
                                .displaySmall
                                ?.copyWith(fontSize: 23.sp))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Icon(Icons.expand_more,
                              color: Colors.black, size: 30.sp),
                        ),
                      ],
                    )),
                SizedBox(width: 140.w),
                TextButton(
                    onPressed: () {
                      Get.bottomSheet(
                        isScrollControlled : true,
                          FractionallySizedBox(
                              heightFactor: 0.8,
                              child : AppointmentSheet(selectedDate: _selectedDate)));
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Icon(Icons.add, color: Colors.black, size: 30.sp)),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SfCalendar(
                        controller: _calendarController,
                        initialSelectedDate: DateTime.now(),
                        allowedViews: const <CalendarView>[
                          CalendarView.month,
                          // CalendarView.week,
                          // CalendarView.day,
                        ],
                        onViewChanged: (ViewChangedDetails details) {
                          _headerText.value =DateFormat('yyyy년 M월').format(details.visibleDates[0]);
                        },
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
                          dayFormat: 'E',
                        ),
                        timeSlotViewSettings: const TimeSlotViewSettings(
                            timelineAppointmentHeight: 100),
                        appointmentBuilder: appointmentBuilder,
                        view: CalendarView.month,
                        cellBorderColor: Colors.transparent,
                        headerHeight: 0,
                        viewHeaderHeight: 40.h,
                        todayHighlightColor: const Color(0xff759CCC),
                        appointmentTimeTextFormat: 'HH:mm',
                        allowDragAndDrop: true
                        // monthViewSettings: const MonthViewSettings(
                        //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                        );
                  }
                }),
          ),
        ],
      ),
    );
  }

  void _showTimeScroller(BuildContext context) {
    Get.bottomSheet(
       Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.sp),
              topLeft: Radius.circular(30.sp),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // 버튼들을 양쪽 끝으로 배치
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back(); // '취소' 버튼을 누르면 모달 시트를 닫음
                      },
                      child: Text(
                        '취소',
                        style:
                            textTheme().displaySmall?.copyWith(fontSize: 17.sp),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = tempDate.value;
                          Get.back();
                        });
                      },
                      child: Text(
                        '완료',
                        style:
                            textTheme().displaySmall?.copyWith(fontSize: 17.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250.h,
                child: ScrollDatePicker(
                  selectedDate: _selectedDate,
                  minimumDate: DateTime(1902, 1, 1),
                  maximumDate: DateTime(2100, 12, 31),
                  locale: Locale('ko'),
                  options: DatePickerOptions(itemExtent: 30.sp, perspective: 0.0001,diameterRatio: 1,backgroundColor: Colors.white),
                  scrollViewOptions: DatePickerScrollViewOptions(
                      year: ScrollViewDetailOptions(
                        alignment: Alignment.centerLeft,
                        label: '년',
                        margin: EdgeInsets.only(right: 50.w),
                        selectedTextStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 25.sp),
                        textStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 23.sp),
                      ),
                      month: ScrollViewDetailOptions(
                        alignment: Alignment.centerLeft,
                        label: '월',
                        margin: EdgeInsets.only(right: 50.w),
                        selectedTextStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 23.sp),
                        textStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 23.sp,color:Colors.grey.shade600),
                      ),
                      day: ScrollViewDetailOptions(
                        label: '일',
                        selectedTextStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 25.sp),
                        textStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 23.sp),
                      )),
                  onDateTimeChanged: (DateTime value) {
                    tempDate.value = value;
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
