import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../Calendar/methods/function_event_date.dart';
import '../../Class/class_my_event.dart';
import '../../theme.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({Key? key,required this.myEvent}) : super(key: key);
  final MyEvent myEvent;

  @override
  Widget build(BuildContext context) {
    DateTime startTime = dateStrToKSTDate(myEvent.startTime);
    DateTime endTime = dateStrToKSTDate(myEvent.endTime);
    bool isSameDay = checkIfSameDay(startTime,endTime);

    String dayOfWeekStart = DateFormat('E', 'ko_KR').format(startTime);
    String dayOfWeekEnd = DateFormat('E', 'ko_KR').format(endTime);
    String startFormat = DateFormat('a h:mm', 'ko_KR').format(startTime);
    String endFormat = DateFormat('a h:mm', 'ko_KR').format(endTime);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.sp),
          border: Border.all(
            width: 1.w,
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 1.h),
                    child: Text(dayOfWeekStart,
                        style: textTheme().displaySmall?.copyWith(
                            fontSize: 14.sp, color: Colors.grey)),
                  ),
                  SizedBox(width: 5.w),
                  Text(startTime.day.toString(),
                      style: textTheme().displayMedium?.copyWith(
                          fontSize: 16.sp, color: const Color(0xff759CCC))),
                ],
              ),
              isSameDay ? Container() :
              Transform.rotate(
                  angle: 90 * 3.14159265 / 180,
                  child: Icon(Icons.horizontal_rule_outlined,
                      size: 10.sp, color: Colors.grey)),
              isSameDay ? Container() :
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 1.h),
                    child: Text(dayOfWeekEnd,
                        style: textTheme().displaySmall?.copyWith(
                            fontSize: 14.sp, color: Colors.grey)),
                  ),
                  SizedBox(width: 5.w),
                  Text(endTime.day.toString(),
                      style: textTheme().displayMedium?.copyWith(
                          fontSize: 17.sp, color: const Color(0xff759CCC))),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.w, 0, 13.w, 0),
            height: 53.h,
            width: 5.w,
            decoration: BoxDecoration(
              color: Color(0xffD8EAF9),
              borderRadius: BorderRadius.circular(5.sp),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(myEvent.summary,
                  style: textTheme()
                      .displaySmall
                      ?.copyWith(fontSize: 16.sp, color: Colors.black)),
              Text(
                '$startFormat ~ $endFormat',
                style: textTheme()
                    .displayMedium
                    ?.copyWith(fontSize: 13.sp, color: Colors.grey.shade400),
              )
            ],
          )
        ]));
  }
}
