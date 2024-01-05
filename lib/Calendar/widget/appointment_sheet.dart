import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kobi/Calendar/methods/function_event_date.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

import '../../function_http_request.dart';
import '../../theme.dart';
import 'custom_time_picker.dart';

class AppointmentSheet extends StatefulWidget {
  AppointmentSheet({super.key, required this.selectedDate});

  DateTime selectedDate;

  @override
  State<AppointmentSheet> createState() => _AppointmentSheetState();
}

class _AppointmentSheetState extends State<AppointmentSheet> {
  final summaryController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  RxBool isVisible = false.obs;
  RxString selectedTime = ''.obs;
  RxString selectedTime2 = ''.obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    DateTime endDateInitialize = selectedDate.add(const Duration(days: 2));
    DateTime atEightAM = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 8); //오전8시로 초기화
    DateTime atNineAM = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 9); //오전9시로 초기화
    selectedTime.value = atEightAM.toString();
    selectedTime2.value = atNineAM.toString();
    startDate.value = selectedDate.toString();
    endDate.value = endDateInitialize.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.sp),
          topLeft: Radius.circular(30.sp),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          isVisible.value = false;
        },
        child: SingleChildScrollView(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
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
                    onPressed: () async{
                      print(combineDate(startDate.value, selectedTime.value));
                      print(combineDate(endDate.value, selectedTime2.value));
                      // await httpResponse('/calendar/add', {
                      //   "summary": summaryController.text,
                      //   "location": locationController.text,
                      //   "description": descriptionController.text,
                      // });
                      Get.back();
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                  child: TextFormField(
                    cursorColor: const Color(0xff759CCC),
                    controller: summaryController,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.fromLTRB(15.w, 11.h, 11.w, 15.h),
                        hintText: "제목"),
                    onTap: () {
                      isVisible.value = false;
                    },
                  )),
              Divider(height: 10.w),
              // Container(
              //     padding: EdgeInsets.symmetric(horizontal: 10.w),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text('종일'),
              //         Icon(Icons.add_circle_outline),
              //       ],
              //     )),
              // SizedBox(height: 10.h),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      myTimePicker(
                          context, startDate, selectedTime, isVisible),
                      const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      myTimePicker(context, endDate, selectedTime2, isVisible)
                    ],
                  )),
              Obx(() => Visibility(
                    visible: isVisible.value,
                    maintainSize: false,
                    child: Column(
                      children: [
                        Divider(),
                        SfDateRangePicker(
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            if(args.value.startDate!=null){
                              startDate.value = args.value.startDate.toString();
                            }
                            if(args.value.endDate!=null){
                              endDate.value = args.value.endDate.toString();
                            }
                          },
                          selectionMode: DateRangePickerSelectionMode.range,
                          initialSelectedRange: PickerDateRange(
                              selectedDate.subtract(const Duration(days: 1)),
                              selectedDate.add(const Duration(days: 2))),
                          todayHighlightColor: Color(0xffACCCFF),
                          startRangeSelectionColor: Color(0xff759CCC),
                          endRangeSelectionColor: Color(0xff759CCC),
                          rangeSelectionColor: Color(0xffD8EAF9),
                        ),
                      ],
                    ),
                  )),
              Divider(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextFormField(
                    cursorColor: Color(0xff759CCC),
                    controller: locationController,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.fromLTRB(15.w, 11.h, 11.w, 15.h),
                        hintText: "장소"),
                    onTap: () {
                      isVisible.value = false;
                    },
                  )),
              Divider(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextFormField(
                    cursorColor: Color(0xff759CCC),
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.fromLTRB(15.w, 11.h, 11.w, 15.h),
                      hintText: "메모",
                    ),
                    onTap: () {
                      isVisible.value = false;
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox myTimePicker(BuildContext context, RxString pickDate,
      RxString selectedTime, RxBool isVisible) {
    return SizedBox(
        width: 150.w,
        child: Column(
          children: [
            Obx(() => TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isVisible.value
                        ? const Color(0xff759CCC)
                        : Colors.transparent,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    isVisible.value = true;
                  },
                  child: Text(getMonthAndDay(pickDate.value),
                      style: textTheme().displaySmall?.copyWith(
                          color:
                              isVisible.value ? Colors.white : Colors.black87,
                          fontSize: 17.sp)),
                )),
            Obx(() => TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  picker.DatePicker.showPicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                  }, theme:picker.DatePickerTheme(),
                      onConfirm: (date) {
                    DateTime tempTime = date;
                    selectedTime.value = tempTime.toString();
                    print(selectedTime.value);
                  },
                      pickerModel: CustomPicker(currentTime: DateTime.now()),
                      locale: picker.LocaleType.ko);
                },
                child: Text(formatTime(selectedTime.value),
                    style: textTheme().bodySmall?.copyWith(fontSize: 15.sp))))
          ],
        ));
  }
}

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
String getMonthAndDay(String? dateString){
  if(dateString==null){
    return '';
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