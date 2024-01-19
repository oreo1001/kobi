import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SendAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SendAppBar(this.onSendButtonPressed,{super.key});
  final VoidCallback onSendButtonPressed;

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 40.h, 0, 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios, size: 25.sp)),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: onSendButtonPressed,
                icon: Icon(Icons.send, size: 25.sp)),
          ],
        ),
      ),
    );
  }
}