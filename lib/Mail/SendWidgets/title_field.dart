import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

TextFormField titleField(bool isReply, TextEditingController titleController){
  return TextFormField(
    cursorColor: const Color(0xff759CCC),
    controller: titleController,
    style: textTheme().bodySmall?.copyWith(
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(15.w, 7.h, 15.w, 7.h),
        hintStyle: textTheme().bodySmall?.copyWith(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: isReply? Colors.grey.shade300 : Colors.grey.shade600,
        ),
        hintText: "제목"),
    enabled: !isReply,
    readOnly: isReply,
    onTap: () {},
  );
}