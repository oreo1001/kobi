import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

Row backgroundCalendar(String title, String date,String type){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(10.w,10.h,0,10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: textTheme().displaySmall!.copyWith(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
            Text(date,style: textTheme().displaySmall!.copyWith(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500))
          ],
        ),
      ),
      Container(
          width: 100.w,
          height: 30.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xff4A90FF),
            border: Border.all(color: Colors.white70),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Center(
            child: Text(type,style: textTheme().displaySmall!.copyWith(
                fontSize: 13.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
          ))
    ],
  );
}