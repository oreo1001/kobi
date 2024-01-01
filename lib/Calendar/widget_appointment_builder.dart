import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../theme.dart';

Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
  final Appointment appointment = calendarAppointmentDetails.appointments.first;

  return Row(
    children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 13.w, 0),
          height: 53.h,
          width: 5.w,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(5.sp),
          ),
        ),
      ),
      SizedBox(
        width: calendarAppointmentDetails.bounds.width - 20.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: appointment.subject,
                style: textTheme().displaySmall?.copyWith(fontSize: 13.sp),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,2.h,0,0),
              child: Text(
                '${formatTime(appointment.startTime)} - ${formatTime(appointment.endTime)}',
                textAlign: TextAlign.start,
                style: textTheme().bodySmall?.copyWith(fontSize: 10.sp, color: Colors.grey.shade800),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

// RichText의 높이 계산 함수
double calculateRichTextHeight(String text, double fontSize, int maxLines) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize),
    ),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: double.infinity);

  return textPainter.height;
}

String formatTime(DateTime time) {
  String period = time.hour >= 12 ? '오후' : '오전';
  int hour = time.hour > 12 ? time.hour - 12 : time.hour;
  String minute = time.minute < 10 ? '0${time.minute}' : '${time.minute}';

  return '$period $hour:$minute';
}