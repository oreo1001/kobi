import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Dialog/widget/schedule_widget.dart';
import '../Class/class_my_event.dart';

import '../Mail/class_email.dart';
import '../theme.dart';

class AutoDialog extends StatefulWidget {
  AutoDialog({super.key,required this.testMail, required this.event});
  TestMail testMail;
  MyEvent event;

  @override
  State<AutoDialog> createState() => _AutoDialogState();
}

class _AutoDialogState extends State<AutoDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.w,30.h,10.w,20.h),
                  child: Text('이 메일을 읽고 자동으로 일정에 등록했어요.',
                      style: textTheme().bodySmall?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.sp),
                    border: Border.all(
                      width: 1.w,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: 10.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text('받는사람',
                                  style:
                                  textTheme().bodySmall?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ))),
                          SizedBox(width: 5.w),
                          Container(
                              height: 40.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: const Color(0xffD8EAF9),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(13.sp)),
                              ),
                              child: Text(widget.testMail.emailAddress,
                                  style: textTheme()
                                      .bodySmall
                                      ?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ))),
                        ],
                      ),
                      Divider(color: Colors.grey.shade300),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.h,10.h,0,10.h),
                        alignment: Alignment.centerLeft,
                        child: Text(widget.testMail.title,style: textTheme()
                            .bodySmall
                            ?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                      ),
                      Divider(color: Colors.grey.shade300),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.h,10.h,0,10.h),
                        alignment: Alignment.centerLeft,
                        child: Text(widget.testMail.body,style: textTheme()
                            .bodySmall
                            ?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Icon(Icons.keyboard_double_arrow_down, size:30.sp),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ScheduleWidget(myEvent: widget.event),
          ),
          TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("캘린더로 이동",
                    style: textTheme().displayMedium?.copyWith(
                        fontSize: 15.sp, color: Colors.black)),
                Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 3.h, 0, 0),
                  child:
                  Icon(Icons.arrow_forward_ios, size: 15.sp),
                )
              ],
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

void showAutoDialog(TestMail testMail,MyEvent event) {
  Get.dialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      AutoDialog(event : event, testMail: testMail,)
  );
}
