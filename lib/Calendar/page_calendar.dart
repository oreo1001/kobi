import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

import '../theme.dart';
import 'custom_picker.dart';
import 'methods/get_calendar_source.dart';
import 'methods/json_to_appointment.dart';
import 'widget_appointment_builder.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  DateTime _selectedDate = DateTime.now();
  Rx<DateTime> tempDate = DateTime.now().obs;
  String _headerText = '';
  String _range = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    });
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    _headerText = DateFormat('yyyy년 M월').format(now);
  }

  @override
  Widget build(BuildContext context) {
    _calendarController.displayDate = _selectedDate; //달력 보여주는 날짜
    _calendarController.selectedDate = _selectedDate; //달력에서 선택된 날짜
    _headerText = DateFormat('yyyy년 M월').format(_selectedDate); //2023년 12월
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
                        Text(_headerText,
                            style: textTheme()
                                .displaySmall
                                ?.copyWith(fontSize: 23.sp)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Icon(Icons.expand_more,
                              color: Colors.black, size: 30.sp),
                        ),
                      ],
                    )),

                SizedBox(width: 60.w),
                TextButton(
                    onPressed: () {
                      Get.toNamed('/test');
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                    child: Icon(Icons.telegram_outlined, color: Colors.black, size: 30.sp)),
                TextButton(
                    onPressed: () {
                      addAppointmentSheet(context,_selectedDate,_onSelectionChanged);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,),
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
                        /// 정원 추가 ///
                        // firstDayOfWeek: 1,
                        controller: _calendarController,
                        initialSelectedDate: DateTime.now(),
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
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
                  scrollViewOptions: DatePickerScrollViewOptions(
                      year: ScrollViewDetailOptions(
                        label: '년',
                        margin: EdgeInsets.only(right: 20.w),
                        selectedTextStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 20.sp),
                        textStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 18.sp),
                      ),
                      month: ScrollViewDetailOptions(
                        label: '월',
                        margin: EdgeInsets.only(right: 20.w),
                        selectedTextStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 20.sp),
                        textStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 18.sp),
                      ),
                      day: ScrollViewDetailOptions(
                        label: '일',
                        selectedTextStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 20.sp),
                        textStyle:
                            textTheme().displaySmall!.copyWith(fontSize: 18.sp),
                      )),
                  onDateTimeChanged: (DateTime value) {
                    tempDate.value = value;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef DateRangePickerCallback = void Function(DateRangePickerSelectionChangedArgs);

void addAppointmentSheet(BuildContext context, DateTime selectedDate ,DateRangePickerCallback onDateSelection ) {
  print(selectedDate);
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.sp),
              topLeft: Radius.circular(30.sp),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                      },
                      child: Text(
                        '저장',
                        style:
                        textTheme().displaySmall?.copyWith(fontSize: 17.sp),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    child: TextFormField(
                      cursorColor: Color(0xff759CCC),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.fromLTRB(15.w,11.h,11.w,15.h),
                          hintText: "제목"),
                    )
                ),
                Divider(height: 10.w),
                Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('종일'),
                    Icon(Icons.add_circle_outline),
                  ],
                )),
                SizedBox(height:10.h),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150.w,
                            height: 50.h,
                            child: Column(
                              children: [
                                Text('${selectedDate.month}월 ${selectedDate.day}일'),
                                Text('오전 8:00'),
                              ],
                            )),
                        Icon(Icons.add_circle_outline),
                        Container(
                            width: 150.w,
                            height: 50.h,
                            child: Column(
                              children: [
                                Text('${selectedDate.month}월 ${selectedDate.day}일'),
                                Text('오전 8:00'),
                              ],
                            )),
                      ],
                    )),
                Divider(),
                TextButton(
                    onPressed: () {
                      picker.DatePicker.showTime12hPicker(context,
                          showTitleActions: true, onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          },
                          onConfirm: (date) {
                            print('confirm $date');
                          },
                          currentTime: DateTime.now());
                    },
                    child: Text(
                      'show 12H time picker with AM/PM',
                      style: TextStyle(color: Colors.blue),
                    )),
                TextButton(
                    onPressed: () {
                      picker.DatePicker.showPicker(context, showTitleActions: true,
                          onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            print('confirm $date');
                          },
                          pickerModel: CustomPicker(currentTime: DateTime.now()),
                          locale: picker.LocaleType.en);
                    },
                    child: Text(
                      'show custom time picker,\nyou can custom picker model like this',
                      style: TextStyle(color: Colors.blue),
                    )),
                Divider(),
                  SfDateRangePicker(
                    onSelectionChanged: onDateSelection,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  ),
                Divider(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TextFormField(
                      cursorColor: Color(0xff759CCC),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.fromLTRB(15.w,11.h,11.w,15.h),
                          hintText: "장소"),
                    )
                ),
                Divider(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TextFormField(
                      cursorColor: Color(0xff759CCC),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.fromLTRB(15.w,11.h,11.w,15.h),
                          hintText: "메모"),
                    )
                ),

              ],
            ),
          ),
        ),
      );
    },
  );
}