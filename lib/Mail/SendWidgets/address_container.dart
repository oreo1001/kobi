import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

Container addressContainer(String sendMailAddress,VoidCallback clearAddress){
  return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xffD8EAF9),
        shape: BoxShape.rectangle,
        borderRadius:
        BorderRadius.all(Radius.circular(13.sp)),
      ),
      child: Row(
        children: [
          Text(sendMailAddress,
              style: textTheme().bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
          SizedBox(
            height: 20.h,
            width: 23.w,
            child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: clearAddress,
                icon: Icon(Icons.close, size: 20.sp)),
          ),
        ],
      ));
}