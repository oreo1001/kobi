import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Main/page_main.dart';
import '../../theme.dart';
import '../class_email.dart';
import '../page_thread.dart';

class SentCompleted extends StatelessWidget {
  const SentCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body : Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Message was sent successfully.',style: textTheme().bodySmall!.copyWith(
            fontWeight: FontWeight.w500,color:Colors.black, fontSize: 17.sp
        )),
        SizedBox(height:30.h),
        TextButton(onPressed: (){ Get.off(() => MainPage(2));}, child: Text('Go to mailList',style: textTheme().bodySmall!.copyWith(
            fontWeight: FontWeight.w700,color:const Color(0xff4A90FF), fontSize: 15.sp
        )))
      ],
    )));
  }
}