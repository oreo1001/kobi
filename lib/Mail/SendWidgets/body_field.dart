import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

SingleChildScrollView bodyField (BuildContext context, TextEditingController bodyController) {
  return SingleChildScrollView(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Colors.transparent,
        height: 450.h -
            MediaQuery
                .of(context)
                .viewInsets
                .bottom, //키보드 자판 위젯 고려
        child: TextFormField(
          cursorColor: const Color(0xff759CCC),
          controller: bodyController,
          maxLines: null,
          style: textTheme().bodySmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
              hintStyle: textTheme().bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
              hintText: "content"),
        ),
      ),
    ),
  );
}