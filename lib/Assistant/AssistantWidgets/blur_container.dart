import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme.dart';

Container blurContainer(String title, String body, Icon icon, Widget widget){
  return Container(
      width: 350.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white70),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2.sp,
            blurRadius: 1.sp,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 20.h, 0, 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: textTheme().displaySmall!.copyWith(
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Text(body,
                        style: textTheme().displaySmall!.copyWith(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.w, 20.h, 10.w, 5.h),
                child: icon,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Divider(
                indent: 10.w,
                endIndent: 10.w,
                color: Colors.grey.shade200),
          ),
          widget
        ],
      ));
}