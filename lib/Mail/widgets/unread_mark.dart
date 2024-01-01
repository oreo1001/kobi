import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../class_email.dart';
import '../methods/function_parsing.dart';

dynamic unreadMark (List<Message> messageList) {
  return Positioned(
    bottom: 5.h,
    right: 5.h,
    child: Container(
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
                fontSize: 14.sp)
        ),
      ),
    ),
  );
}