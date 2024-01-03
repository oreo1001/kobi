import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../class_email.dart';
import '../methods/function_parsing.dart';

Widget unreadMark (List<Message> messageList) {
  return Visibility(
    visible: unreadMessageCount(messageList)==0 ? false : true,
    child: Positioned(
      bottom: 10.h,
      right: 20.h,
      child: Container(
        width: 25.w,
        height: 25.h,
        padding: EdgeInsets.fromLTRB(7.w,5.h,7.w,7.h),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
              unreadMessageCount(messageList).toString(),
              style: textTheme()
                  .displayLarge
                  ?.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp)
          ),
        ),
      ),
    ),
  );
}