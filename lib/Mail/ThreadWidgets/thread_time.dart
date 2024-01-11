import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../class_email.dart';
import '../methods/function_mail_date.dart';

Row threadTime(Message message,String sentUsername){
  return Row(
    mainAxisAlignment: message.sentByUser
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    children: [
      RichText(
        maxLines: 1,
        softWrap: true,
        text: TextSpan(children: [
          TextSpan(
            text: message.sentByUser
                ? ''
                : sentUsername,
            style: textTheme()
                .displayMedium
                ?.copyWith(fontSize: 16.sp),
          ),
          WidgetSpan(
            child: SizedBox(
              width: 10.w,
            ),
          ),
          TextSpan(
              text: threadDateString(
                  message.date),
              style: textTheme().bodySmall?.copyWith(
                  color: Colors.grey, fontSize: 10.sp)),
          WidgetSpan(
            child: SizedBox(
              width: 10.w,
            ),
          ),
          TextSpan(
            text: message.sentByUser
                ? '나'
                : '',
            style: textTheme()
                .displayMedium
                ?.copyWith(fontSize: 16.sp),
          ),
        ]),
      ),
    ],
  );
}