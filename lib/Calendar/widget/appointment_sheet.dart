import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

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
    selectedTime.value = formatTime(atEightAM);
    selectedTime2.value = formatTime(atNineAM);
    startDate.value = DateFormat('M월 d일').format(selectedDate);
    endDate.value = DateFormat('M월 d일').format(endDateInitialize);
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
                    onPressed: () {
                      print(summaryController.text);
                      print(locationController.text);
                      print(descriptionController.text);
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
                            startDate.value = DateFormat('M월 d일')
                                .format(args.value.startDate);
                            endDate.value = DateFormat('M월 d일')
                                .format(args.value.endDate);
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
                  child: Text(pickDate.value,
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
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    DateTime tempTime = date;

                    selectedTime.value = formatTime(tempTime);
                  },
                      pickerModel: CustomPicker(currentTime: DateTime.now()),
                      locale: picker.LocaleType.ko);
                },
                child: Text(selectedTime.value,
                    style: textTheme().bodySmall?.copyWith(fontSize: 15.sp))))
          ],
        ));
  }
}

String formatTime(DateTime date) {
  int hour = date.hour;
  int minute = date.minute;
  String period = hour >= 12 ? "오후" : "오전";
  hour = hour % 12;
  if (hour == 0) {
    hour = 12;
  }
  return '$period ${hour.toString()}:${minute.toString().padLeft(2, '0')}';
}
