import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

myInfoButton(VoidCallback onPressed, String text, TextStyle textStyle) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 5.h),
    child: SizedBox(
      height: 50.h,
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0.sp, 0.sp),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey.shade800,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              )),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(text, style: textStyle),
              const Spacer(),
            ],
          )),
    ),
  );
}