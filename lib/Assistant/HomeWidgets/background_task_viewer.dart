import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/Class/background_task_message.dart';
import 'package:kobi/Assistant/HomeWidgets/background_task.dart';

class BackgroundTaskViewer extends StatelessWidget {
  BackgroundTaskViewer({super.key, required this.backgroundTaskMessages});

  List<BackgroundTaskMessage> backgroundTaskMessages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // 그림자 색상
            spreadRadius: 2, // 그림자 확장 범위
            blurRadius: 1, // 그림자 흐림 정도
            offset: const Offset(0, 1), // 그림자 위치
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: backgroundTaskMessages.map((backgroundTaskMessage) =>
            BackgroundTask(backgroundTaskMessage: backgroundTaskMessage)).toList()
      ),
    );
  }
}
