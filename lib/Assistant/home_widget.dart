import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Assistant/HomeWidgets/active_extension_list.dart';
import 'package:kobi/Assistant/HomeWidgets/extension_report.dart';
import 'package:kobi/theme.dart';

import '../Class/class_my_event.dart';
import '../Mail/class_email.dart';
import '../Mail/methods/function_mail_date.dart';
import '../function_http_request.dart';
import 'Class/background.dart';
import 'Class/extension_class.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  static Future getBackground() async {
    Map<String, dynamic> responseMap =
        await httpResponse('/assistant/background', {});
    var background = loadBackgroundFromJson(responseMap);
    return background;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getBackground(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'));
          } else {
            var background = snapshot.data as Background;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '자리를 비우신 동안 커리비가 한 일',
                        style: textTheme().bodyMedium!.copyWith(),
                      )),
                  SizedBox(
                    height: 10.h,
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
                        // extensionLogInfoList: [
                        //   ExtensionLogInfo(
                        //       date: homeDateString('2024-01-03T14:00:00+09:00'),
                        //       log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!',
                        //       testMail: TestMail(
                        //           title: 'test',
                        //           body: '내용입니다.',
                        //           emailAddress: 'ohsimon77@naver.com',
                        //           reply: true),
                        //       event: MyEvent(
                        //           eventId: 'ddd',
                        //           summary: 'hihihihi',
                        //           startTime: '2019-02-23T14:00:00+09:00',
                        //           endTime: '2019-02-23T14:00:00+09:00')),
                        //   ExtensionLogInfo(
                        //       date: homeDateString('2024-01-03T12:00:00+09:00'),
                        //       log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!',
                        //       testMail: TestMail(
                        //           title: 'test',
                        //           body: '내용입니다.',
                        //           emailAddress: 'ohsimon77@naver.com',
                        //           reply: false),
                        //       event: MyEvent(
                        //           eventId: 'ddd',
                        //           summary: 'hihihihi',
                        //           startTime: '2019-02-23T14:00:00+09:00',
                        //           endTime: '2019-02-23T14:00:00+09:00')),
                        //   ExtensionLogInfo(
                        //       date: homeDateString('2024-01-02T14:00:00+09:00'),
                        //       log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!',
                        //       testMail: TestMail(
                        //           title: 'test',
                        //           body: '내용입니다.',
                        //           emailAddress: 'ohsimon77@naver.com',
                        //           reply: false),
                        //       event: MyEvent(
                        //           eventId: 'ddd',
                        //           summary: 'hihihihi',
                        //           startTime: '2019-02-23T14:00:00+09:00',
                        //           endTime: '2019-02-23T14:00:00+09:00')),
                        //   ExtensionLogInfo(
                        //       date: homeDateString('2024-01-02T13:00:00+09:00'),
                        //       log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!',
                        //       testMail: TestMail(
                        //           title: 'test',
                        //           body: '내용입니다.',
                        //           emailAddress: 'ohsimon77@naver.com',
                        //           reply: false),
                        //       event: MyEvent(
                        //           eventId: 'ddd',
                        //           summary: 'hihihihi',
                        //           startTime: '2019-02-23T14:00:00+09:00',
                        //           endTime: '2019-02-23T14:00:00+09:00')),
                        // ]
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
            );
          }
        });
  }
}
