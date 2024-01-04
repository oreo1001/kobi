import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Dialog/widget/schedule_widget.dart';
import '../Class/class_my_event.dart';
import '../theme.dart';

void showEventDialog(MyEvent event) {
  Get.dialog(AlertDialog(
    // alignment: Alignment.topCenter,
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    title: Text('새로운 일정이 추가되었습니다!',
        style: textTheme().displayLarge?.copyWith(fontSize: 18.sp)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScheduleWidget(myEvent : event),
        TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("캘린더로 이동",
                  style: textTheme()
                      .displayMedium
                      ?.copyWith(fontSize: 15.sp, color: Colors.black)),
              Padding(
                padding: EdgeInsets.fromLTRB(3.w, 3.h, 0, 0),
                child: Icon(Icons.arrow_forward_ios, size: 15.sp),
              )
            ],
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  ));
}
