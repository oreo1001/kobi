import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../theme.dart';

void showInvalidEmailDialog() {
  Get.dialog(AlertDialog(
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    content: SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: 35.w,
              height: 35.h,
              padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 7.h),
              decoration: BoxDecoration(
                // color: Colors.yellow.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning,size:20.sp,color:Colors.black)),
          Container(
            padding: EdgeInsets.fromLTRB(0,15.h,0,0),
            child: Text('유효하지 않은 이메일입니다.',style: textTheme().bodySmall!.copyWith(
                fontWeight: FontWeight.w700,color:Colors.black, fontSize: 15.sp
            )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0,15.h,0,0),
            child: Text('받는 사람 주소를 입력해 주세요.',style: textTheme().bodySmall!.copyWith(
                color:Colors.black, fontSize: 13.sp
            )),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            width:200.w,
            height:50.h,
            child: ElevatedButton(onPressed: (){
              Get.back();
            },style: ElevatedButton.styleFrom(
              surfaceTintColor: const Color(0xffACCCFF),
              backgroundColor: const Color(0xffACCCFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
              ),
            ), child: Text('확인',style: textTheme().bodySmall!.copyWith(
                fontWeight: FontWeight.w700,color:Colors.white
            )
            ),)
        ),
      )
    ],
  ));
}
