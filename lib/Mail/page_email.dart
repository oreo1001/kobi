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

  @override
  void initState() {
    super.initState();
    // getMail();
  }

  Future getMail() async {
    Map<String, dynamic> responseMap =
        await httpResponse('/email/emailList', {});
    emailList = loadEmailsFromJson(responseMap['emailList']);
    return emailList;
  }

  Future getThreads(List<dynamic> threads) async {
    threadList = parsingThreadsFromEmail(threads);
  }

  @override
  Widget build(BuildContext context) {
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
                title: RichText(
                    maxLines: 1,
                    softWrap: true,
                    text: TextSpan(children: [
                      TextSpan(
                          text: '내 메일함',
                          style: textTheme()
                              .displayMedium
                              ?.copyWith(fontSize: 20.sp)),
                      WidgetSpan(
                        child: SizedBox(
                          width: 5.w,
                        ),
                      ),
                      TextSpan(
                          text: emailList.length.toString(),
                          style: textTheme().displaySmall?.copyWith(
                              fontSize: 18.sp, color: Colors.blueGrey)),
                    ])),
              ),
              body: ListView.builder(
                itemCount: emailList.length,
                itemBuilder: (context, index) {
                  final email = emailList[index];
                  threadId = email.threadId;
                  var threads = email.messages;
                  getThreads(threads);
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ThreadPage(emailList[index]));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 300.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                    mailDateString(
                                        threadList[threads.length - 1].date),
                                    style: textTheme()
                                        .bodyMedium
                                        ?.copyWith(fontSize: 10.sp)),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
