import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kobi/Calendar/methods/function_event_date.dart';
import 'package:kobi/Controller/appointment_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as picker;

import '../../Class/class_my_event.dart';
import '../../function_http_request.dart';
import '../../theme.dart';
import '../methods/function_appointment_sheet.dart';
import 'custom_time_picker.dart';

class AppointmentSheet extends StatefulWidget {
  AppointmentSheet({super.key, required this.appointment});
  Appointment appointment;
  @override
  State<AppointmentSheet> createState() => _AppointmentSheetState();
}

class _AppointmentSheetState extends State<AppointmentSheet> {
  final summaryController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  // DateTime selectedDate = DateTime.now();
  RxBool isVisible = false.obs;
  RxString selectedTime = ''.obs;
  RxString selectedTime2 = ''.obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;

  @override
  void initState() {
    super.initState();
    locationController.text = widget.appointment.location ?? '';
    descriptionController.text = widget.appointment.notes ?? '';
    summaryController.text = widget.appointment.subject ?? '';
    selectedTime.value = startDate.value = widget.appointment.startTime.toString();
    selectedTime2.value = endDate.value = widget.appointment.endTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisSize: MainAxisSize.min,
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
                  SizedBox(width:150.w),
                  TextButton(
                    onPressed: () {
                      AppointmentController appointmentController = Get.find();
                      appointmentController.deleteAppointment(widget.appointment);
                      Get.back();
                      Get.snackbar(
                        "일정",
                        "삭제하였습니다!",
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    child: Text(
                      '삭제',
                      style:
                      textTheme().displaySmall?.copyWith(fontSize: 17.sp,color:Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime startTimeToBack = combineDate(startDate.value, selectedTime.value);
                      if(checkProperEndDate(endDate.value)) return;
                      DateTime endTimeToBack = combineDate(endDate.value, selectedTime2.value);
                      if(checkIfEarlier(startTimeToBack,endTimeToBack)) return;

                      Appointment myAppointment = Appointment(id: widget.appointment.id, subject : summaryController.text, startTime : startTimeToBack, endTime: endTimeToBack,notes: descriptionController.text,location: locationController.text);
                      MyEvent eventToBack = appointmentToMyEvent(myAppointment);
                      AppointmentController appointmentController = Get.find();
                      appointmentController.updateAppointment(myAppointment);
                      // await httpResponse('/calendar/insertEvent', {
                      //   'event' : eventToBack.toJson()
                      // });
                      Get.back();
                      Get.snackbar(
                        "일정",
                        "수정하였습니다!",
                        snackPosition: SnackPosition.TOP,
                      );
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
                          endDate.value = '';
                        }
                        if(args.value.endDate!=null){
                          endDate.value = args.value.endDate.toString();
                        }
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                          DateTime.parse(startDate.value).toUtc().add(const Duration(hours:9)),
                        DateTime.parse(endDate.value).toUtc().add(const Duration(hours:9))),
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
                      pickerModel: CustomPicker(currentTime: DateTime.now().add(Duration(hours:9))),
                      locale: picker.LocaleType.ko);
                },
                child: Text(formatTime(selectedTime.value),
                    style: textTheme().bodySmall?.copyWith(fontSize: 15.sp))))
          ],
        ));
  }
}