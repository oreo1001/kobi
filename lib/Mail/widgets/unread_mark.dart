import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../class_email.dart';
import '../methods/function_parsing.dart';

dynamic unreadMark (List<Message> messageList) {
  return Positioned(
    bottom: 5.h,
    right: 5.h,
    child: Text(unreadMessageCount(messageList).toString(),
        style: textTheme()
            .displayLarge
            ?.copyWith(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w400,
            fontSize: 17.sp)),
  );
}