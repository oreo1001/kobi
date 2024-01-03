import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Dialog/widget/schedule_widget.dart';

import '../Class/class_my_event.dart';
import '../theme.dart';
void showUpdateEventDialog(Event beforeEvent, Event afterEvent) {  //Map<String, dynamic> beforeEvent, Map<String, dynamic> afterEvent
  Get.dialog(
    AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Text('다음 일정이 변경되었습니다.',
          style: textTheme().displayLarge?.copyWith(fontSize: 18.sp)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScheduleWidget(myEvent : beforeEvent),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Icon(Icons.keyboard_double_arrow_down),
          ),
          ScheduleWidget(myEvent : afterEvent),
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
