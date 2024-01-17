import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../../theme.dart';

Container tempCarousel(){
  return Container(
      width: 170.w,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white70),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2.sp,
            blurRadius: 2.sp,
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
                Text('추가 예정',
                    style: textTheme().displaySmall!.copyWith(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
                SizedBox(width: 20.w),
                Container(
                    width: 39.5.w,
                    height: 39.5.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius:
                        BorderRadius.circular(10.sp),
                        border: Border.all(
                            color:
                            Colors.grey.withOpacity(0.2))),
                    child: Icon(Icons.plus_one,
                        color: const Color(0xff4A90FF))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.w, vertical: 10.h),
            child: WrappedKoreanText(
              '앞으로도 더 추가될 예정이에요!',
              style: textTheme().displaySmall!.copyWith(
                  fontSize: 13.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ));
}