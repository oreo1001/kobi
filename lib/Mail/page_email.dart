import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Mail/page_thread.dart';

import 'class_email.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'function_mail_date.dart';
import 'function_parsing.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  List<Email> emailList = [];
  List<Thread> threadList = [];
  String threadId = '';

  Future getMail() async {
    Map<String, dynamic> responseMap =
        await httpResponse('/email/emailList', {});
    emailList = loadEmailsFromJson(responseMap['emailList']);
    return emailList;
  }

  Future getThreads(List<dynamic> threads) async {
    threadList = parsingThreadsFromEmail(threads);
  }

  final List<Color> colors = [
    Color(0xffB1ECFF),
    Color(0xffFF7D61),
    Color(0xffFF82BE),
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.lightBlueAccent,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return FutureBuilder(
        future: getMail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'));
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 100.h,
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    SizedBox(height : 10.h),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w,0,0,0),
                      child: Text('메일',
                          style: textTheme()
                              .displayMedium
                              ?.copyWith(fontSize: 40.sp)),
                    ),
                  ],
                )
              ),
              body: ListView.builder(
                itemCount: emailList.length,
                itemBuilder: (context, index) {
                  final email = emailList[index];
                  threadId = email.threadId;
                  var threads = email.messages;
                  getThreads(threads);
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.to(() => ThreadPage(emailList[index]));
                    },
                    child:
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0,10.h,15.w,10.h),
                            child: CircleAvatar(
                            radius: 30.sp,
                            backgroundColor: colors[random.nextInt(colors.length)],
                            child: Text(
                              email.name[0],  // 첫 번째 글자만 가져옴
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),),
                          ),
                            SizedBox(
                              width: 270.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(email.name,
                                          style: textTheme()
                                              .displayLarge
                                              ?.copyWith(fontSize: 18.sp)),
                                      SizedBox(width: 5.w),
                                      Text(threadList.length.toString(),
                                          style: textTheme()
                                              .displayLarge
                                              ?.copyWith(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17.sp)),
                                      Spacer(),
                                      SizedBox(
                                        width: 50.w,
                                        child: Text(
                                            mailDateString(
                                                threadList[threads.length - 1].date),
                                            style: textTheme()
                                                .bodyMedium
                                                ?.copyWith(fontSize: 10.sp)),
                                      ),
                                    ],
                                  ),
                                  Text(threadList[threads.length - 1].subject,
                                      style: textTheme()
                                          .displaySmall
                                          ?.copyWith(fontSize: 14.sp)),
                                  Text(threadList[threads.length - 1].body,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: textTheme()
                                          .displaySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.sp,
                                              overflow:
                                                  TextOverflow.ellipsis)),
                                  // Text(email.emailAddress),
                                  // Text(email.threadId),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  );
                },
              ),
            );
          }
        });
  }
}
