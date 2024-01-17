import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Mail/methods/function_thread_data.dart';

import '../../theme.dart';
import '../class_email.dart';

Row condensedMessage(Message message) {
  return Row(
    mainAxisAlignment:
        message.sentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Container(
        width: 350.w,
        margin: EdgeInsets.fromLTRB(5.w,0,5.w,0),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          color: message.sentByUser
              ? const Color(0xff759CCC)
              : const Color(0xffD8EAF9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (message.subject.trim() == '')
                  ? '(제목 없음)'
                  : removeNewlines(message.subject),
              style: textTheme().bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: message.sentByUser ? Colors.white : Colors.black,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.h),
            message.mimeType == "text/plain"
                ? Text(
                    removeNewlines(message.body),
                    style: textTheme().bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color:
                              message.sentByUser ? Colors.white : Colors.black,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(
                    message.snippet,
                    style: textTheme().bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ],
        ),
      ),
    ],
  );
}

String removeNewlines(String text) {
  text = text.replaceAll('\r', '').replaceAll('\n', '');
  return text;
}
