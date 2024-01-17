import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Class/class_my_event.dart';
import 'package:kobi/Dialog/delete_dialog.dart';
import 'package:kobi/Dialog/event_dialog.dart';
import 'package:kobi/Dialog/update_event_dialog.dart';

import '../Assistant/ResponseWidgets/delete_event.dart';
import '../in_app_notification/in_app_notification.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyEvent event = MyEvent(
        eventId: 'ddd',
        summary: '안녕하세요 반갑습니다 안녕하세요 반갑습니다안녕하세요 반갑습니다안녕하세요 반갑습니다안녕하세요 반갑습니다',
        startTime: '2024-02-23T14:00:00+09:00',
        endTime: '2024-02-24T14:00:00+09:00');
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          TextButton(
            onPressed: () {
              showUpdateEventDialog(event,event);
            },
            child: Text('test1'),
          ),
          TextButton(
            onPressed: () {
              InAppNotification.show(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child : DeleteEvent(index: 0)
                  ),
                  duration: const Duration(seconds: 60), context: context);
            },
            child: Text('test2'),
          ),
        ],
      )),
    );
  }
}
