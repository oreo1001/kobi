import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/Class/background_task_message.dart';
import 'package:kobi/Assistant/Methods/change_icon_color.dart';
import 'package:kobi/theme.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class BackgroundTask extends StatelessWidget {
  BackgroundTask({super.key, required this.backgroundTaskMessage});

  BackgroundTaskMessage backgroundTaskMessage;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.5.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.grey.withOpacity(0.2)
              )
            ),
              child: changeIconColor(backgroundTaskMessage.icon, const Color(0xFFACCCFF))
          ),
          SizedBox(width: 30.w,),
          Flexible(
              child: WrappedKoreanText(backgroundTaskMessage.message,
                style: textTheme().bodySmall!.copyWith(fontSize: 14.sp),
              )
          )
        ],
      ),
    );
  }
}
