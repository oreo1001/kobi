import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/Class/extension_class.dart';
import 'package:kobi/theme.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../Methods/change_icon_color.dart';

class ActiveExtension extends StatelessWidget {
  const ActiveExtension({super.key, required this.extensionDescription});

  final ExtensionDescription extensionDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      child: Row(
        children: [
          Container(
              width: 39.5.w,
              height: 39.5.h,
            padding: EdgeInsets.all(6.5.sp),
            decoration: BoxDecoration(
              color: extensionDescription.iconColor,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.grey.withOpacity(0.2)
                )
            ),
            child: changeIconColor(extensionDescription.icon, Colors.white)
          ),
          SizedBox(width: 30.w,),
          Flexible(
              child: WrappedKoreanText(extensionDescription.message,
                style: textTheme().bodySmall!.copyWith(fontSize: 14.sp),
              )
          )
        ],
      ),
    );
  }
}
