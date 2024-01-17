import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../../theme.dart';

Container voiceCarousel(String title, String body,IconData iconWidget){
  return Container(
      width: 170.w,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xff4A90FF),
        border: Border.all(color: Colors.white70),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff4A90FF).withOpacity(0.2),
            spreadRadius: 2.sp,
            blurRadius: 1.sp,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 15.h, 0, 0.h),
            child: Row(
              children: [
                Text(title,
                    style: textTheme().displaySmall!.copyWith(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                SizedBox(width: 20.w),
                Container(
                    width: 39.5.w,
                    height: 39.5.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.sp),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.2))),
                    child: Icon(iconWidget,
                        color: const Color(0xff4A90FF))),
              ],
            ),
          ),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
            child: WrappedKoreanText(
              body,
              style: textTheme().displaySmall!.copyWith(
                  fontSize: 13.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ));
}