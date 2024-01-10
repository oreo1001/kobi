import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Main/page_main.dart';
import '../../theme.dart';
import '../class_email.dart';
import '../page_thread.dart';

class SentCompleted extends StatelessWidget {
  const SentCompleted({super.key, required this.currentThread});
  final Thread currentThread ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body : Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('메일을 성공적으로 보냈습니다.',style: textTheme().bodySmall!.copyWith(
            fontWeight: FontWeight.w500,color:Colors.black, fontSize: 17.sp
        )),
        SizedBox(height:30.h),
        TextButton(onPressed: (){ Get.off(() => MainPage());}, child: Text('홈으로 돌아가기',style: textTheme().bodySmall!.copyWith(
            fontWeight: FontWeight.w700,color:const Color(0xff4A90FF), fontSize: 15.sp
        )))
      ],
    )));
  }
}