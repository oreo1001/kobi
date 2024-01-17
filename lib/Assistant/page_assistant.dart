import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/HomeWidgets/extension_report.dart';

import '../Loading/loading_widget.dart';
import '../Mail/class_email.dart';
import '../Mail/methods/function_mail_date.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'Class/background.dart';
import 'Class/extension_class.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  static Future getBackground() async {
    Map<String, dynamic> responseMap =
        await httpResponse('/assistant/background', {});
    var background = loadBackgroundFromJson(responseMap);
    background = Background(mailFiltering: MailFiltering(log: 'dd',date:DateTime.now().toString()), autoCalendarList: []);
    return background;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getBackground(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
              return const LoadingWidget();
            } else {
              var background = snapshot.data as Background;
              return SingleChildScrollView(
                child: Container(
                  height: 550.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 50.h),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '자리를 비우신 동안 커리비가 한 일',
                            style: textTheme().bodyMedium!.copyWith(),
                          )),
                      SizedBox(
                        height: 30.h,
                      ),
                      ExtensionReport(
                          extensionReportInfo: ExtensionReportInfo(
                              extensionDescription: ExtensionDescription(
                                  icon: const Icon(Icons.email_outlined),
                                  iconColor: const Color(0xFFFF7177),
                                  message: '이메일 자동 분류'),
                              extensionLogInfoList: [
                                ExtensionLogInfo(date: '', log: background.mailFiltering.log),
                              ])),
                      SizedBox(
                        height: 10.h,
                      ),
                      ExtensionReport(
                        extensionReportInfo: ExtensionReportInfo(
                          extensionDescription: ExtensionDescription(
                              icon: const Icon(Icons.edit_calendar_outlined),
                              iconColor: const Color(0xFFFFA053),
                              message: '메일에서 일정 자동 등록'),
                          extensionLogInfoList: background.autoCalendarList
                              .map((AutoCalendar autoCalendar) {
                            return ExtensionLogInfo(
                                date: homeDateString(autoCalendar.date),
                                log: autoCalendar.log,
                                testMail: TestMail(
                                    title: autoCalendar.mail.subject,
                                    body: autoCalendar.mail.body,
                                    emailAddress: autoCalendar.mail.emailAddress,
                                    reply: false),
                                event: autoCalendar.event);
                          })
                              .toList()
                              .cast<ExtensionLogInfo>(),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ExtensionReport(
                        extensionReportInfo: ExtensionReportInfo(
                            extensionDescription: ExtensionDescription(
                                icon: const Icon(Icons.task_outlined),
                                iconColor: const Color(0xFF5FA0E2),
                                message: '메일 작성 비서'),
                            extensionLogInfoList: [
                              ExtensionLogInfo(
                                  date: '',
                                  log:
                                  '오른쪽 아래 마이크 버튼을 눌러주세요.\n\'○○○에게 메일 보내줘.\'라고 말해보세요.'),
                            ]),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ExtensionReport(
                        extensionReportInfo: ExtensionReportInfo(
                            extensionDescription: ExtensionDescription(
                                icon: const Icon(Icons.search_outlined),
                                iconColor: const Color(0xFF965DD9),
                                message: '음성 비서'),
                            extensionLogInfoList: [
                              ExtensionLogInfo(
                                  date: '',
                                  log:
                                      '오른쪽 아래 마이크 버튼을 눌러주세요.\n\'이번주 내 일정 알려줄래?\'라고 말해보세요.'),
                            ]),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
