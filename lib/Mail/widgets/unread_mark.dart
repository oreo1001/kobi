import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kobi/Controller/mail_controller.dart';
import '../../theme.dart';

class UnreadMark extends StatefulWidget {
  UnreadMark(this.unreadCount,{super.key});
  RxInt unreadCount;
  @override
  State<UnreadMark> createState() => _UnreadMarkState();
}

class _UnreadMarkState extends State<UnreadMark> {
  MailController mailController = Get.find();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Visibility(
            visible: widget.unreadCount.value == 0 ? false : true,
            child: Positioned(
              bottom: 10.h,
              right: 20.h,
              child: Container(
                width: 25.w,
                height: 25.h,
                padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 7.h),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.unreadCount.value.toString(),
                    style: textTheme()
                        .displayLarge
                        ?.copyWith(color: Colors.white, fontSize: 10.sp),
                  ),
                ),
              ),
            ),
          );
      }
    );
  }
}
