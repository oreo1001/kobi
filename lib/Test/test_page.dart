import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/ResponseWidgets/delete_event.dart';
import 'package:kobi/Assistant/ResponseWidgets/describe_user_query.dart';
import 'package:kobi/Dialog/page_auto_dialog.dart';

import '../Assistant/ResponseWidgets/create_email.dart';
import '../Assistant/ResponseWidgets/insert_event.dart';
import '../Assistant/ResponseWidgets/patch_event.dart';
import '../in_app_notification/in_app_notification.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String sendMailAddress = 'careebee@wonmo.net';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          child: Text('test'),
          onPressed: () {
            InAppNotification.show(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  padding: EdgeInsets.fromLTRB(5.w,0,5.w,20.h),
                  child: DescribeUserQuery()),
                context: context
            );
          },
        ),
      ),
    );
  }
}
