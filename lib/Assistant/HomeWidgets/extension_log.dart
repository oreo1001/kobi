import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/theme.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../Class/extension_class.dart';

class ExtensionLog extends StatelessWidget {
  const ExtensionLog({super.key, required this.extensionLogInfo});

  final ExtensionLogInfo extensionLogInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 3.h),
      child: Row(
        children: [
          SizedBox(
              width: 50.w,
              height: 39.5.h,
              child: Center(child: Text(extensionLogInfo.date, style: textTheme().bodySmall!.copyWith(fontSize: 10.sp),))),
          SizedBox(width: 20.w,),
          Flexible(
              child: WrappedKoreanText(extensionLogInfo.log,
                style: textTheme().displaySmall!.copyWith(fontSize: 12.sp),
              )
          )
        ],
      ),
    );
  }
}
