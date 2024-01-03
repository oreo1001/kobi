import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/HomeWidgets/active_extension_list.dart';
import 'package:kobi/Assistant/HomeWidgets/extension_report.dart';
import 'package:kobi/theme.dart';

import '../Mail/methods/function_mail_date.dart';
import 'Class/extension_class.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(height: 40.h,),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('자리를 비우신 동안 커리비가 한 일', style: textTheme().bodyMedium!.copyWith(),)
          ),
          SizedBox(height: 10.h,),
          ExtensionReport(extensionReportInfo: ExtensionReportInfo(
              extensionDescription: ExtensionDescription(
                  icon: const Icon(Icons.email_outlined),
                  iconColor: const Color(0xFFFF7177),
                  message: '이메일 자동 분류'),
              extensionLogInfoList: [
                ExtensionLogInfo(date: '', log: '이메일 24건을 처리했어요!'),
              ])
          ),
          SizedBox(height: 10.h,),
          ExtensionReport(extensionReportInfo: ExtensionReportInfo(
              extensionDescription: ExtensionDescription(
                  icon: const Icon(Icons.edit_calendar_outlined),
                  iconColor: const Color(0xFFFFA053),
                  message: '메일에서 일정 자동 등록'),
              extensionLogInfoList: [
                ExtensionLogInfo(date: homeDateString('2024-01-03T14:00:00+09:00'), log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!'),
                ExtensionLogInfo(date: homeDateString('2024-01-03T12:00:00+09:00'), log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!'),
                ExtensionLogInfo(date: homeDateString('2024-01-02T14:00:00+09:00'), log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!'),
                ExtensionLogInfo(date: homeDateString('2024-01-02T13:00:00+09:00'), log: '김정모와 1월 7일 영화보기 일정 캘린더에 추가했어요!'),
              ]),),
          SizedBox(height: 10.h,),
          ExtensionReport(extensionReportInfo: ExtensionReportInfo(
              extensionDescription: ExtensionDescription(
                  icon: const Icon(Icons.task_outlined),
                  iconColor: const Color(0xFF5FA0E2),
                  message: '메일 작성 비서'),
              extensionLogInfoList: [
                ExtensionLogInfo(date: '', log: 'TODO : 사용법을 적어주세요'),
              ]),),

          SizedBox(height: 10.h,),
          ExtensionReport(extensionReportInfo: ExtensionReportInfo(
              extensionDescription: ExtensionDescription(
                  icon: const Icon(Icons.search_outlined),
                  iconColor: const Color(0xFF965DD9),
                  message: '음성 비서'),
              extensionLogInfoList: [
                ExtensionLogInfo(date: '', log: 'TODO : 사용법을 적어주세요'),
              ]),),

        ],
      ),
    );
  }
}
