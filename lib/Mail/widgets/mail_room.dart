import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Mail/class_email.dart';

import '../../theme.dart';
import '../methods/function_mail_date.dart';

Row mailRoom (Color profileColor, Thread thread, List<Message> messageList) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0,10.h,15.w,10.h),
        child: CircleAvatar(
          radius: 30.sp,
          backgroundColor: profileColor,
          child: Text(
            thread.name[0],  // 첫 번째 글자만 가져옴
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),),
      ),
      SizedBox(
        width: 270.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(thread.name,
                    style: textTheme()
                        .displayLarge
                        ?.copyWith(fontSize: 18.sp)),
                const Spacer(),
                SizedBox(
                  width: 50.w,
                  child: Text(
                      mailDateString(
                          messageList[messageList.length - 1].date),
                      style: textTheme()
                          .bodyMedium
                          ?.copyWith(fontSize: 10.sp)),
                ),
              ],
            ),
            Text(messageList[messageList.length - 1].subject,
                style: textTheme()
                    .displaySmall
                    ?.copyWith(fontSize: 14.sp)),
            Text(messageList[messageList.length - 1].body,
                maxLines: 1,
                softWrap: true,
                style: textTheme()
                    .displaySmall
                    ?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    overflow:
                    TextOverflow.ellipsis)),
            // Text(email.emailAddress),
          ],
        ),
      ),
    ],
  );
}