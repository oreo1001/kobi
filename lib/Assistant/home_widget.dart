import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/HomeWidgets/background_task_viewer.dart';
import 'package:kobi/theme.dart';
import 'Class/background_task_message.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(height: 50.h,),
          Align(
            alignment: Alignment.centerLeft,
              child: Text('적용 중인 Extension', style: textTheme().bodyMedium!.copyWith(),)
          ),
          SizedBox(height: 10.h,),
          BackgroundTaskViewer(
            backgroundTaskMessages: [
              BackgroundTaskMessage(
                  icon: const Icon(Icons.email_outlined),
                  message: '이메일 자동 분류'),
              BackgroundTaskMessage(
                  icon: const Icon(Icons.edit_calendar_outlined),
                  message: '메일에서 일정 자동 등록'),
              BackgroundTaskMessage(
                  icon: const Icon(Icons.file_copy_outlined),
                  message: '메일 작성 비서'),
              BackgroundTaskMessage(
                  icon: const Icon(Icons.file_copy_outlined),
                  message: '일정 조회 비서'),
            ]
        ),
          SizedBox(height: 40.h,),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('자리를 비우신 동안 커리비가 한 일', style: textTheme().bodyMedium!.copyWith(),)
          ),
          SizedBox(height: 20.h,),
          BackgroundTaskViewer(
              backgroundTaskMessages: [
                BackgroundTaskMessage(
                    icon: const Icon(Icons.email_outlined),
                    message: '수신 메일 5건 중 광고 및 스팸 메일 3건을 정리했어요.'),
                BackgroundTaskMessage(
                    icon: const Icon(Icons.edit_calendar_outlined),
                    message: '메일에서 찾은 일정 2건을 캘린더에 추가했어요.'),
                BackgroundTaskMessage(
                    icon: const Icon(Icons.file_copy_outlined),
                    message: '메일함에서 전자세금계산서를 PDF 파일로 변환하여 구글 드라이브에 저장했어요.'),

                BackgroundTaskMessage(
                    icon: const Icon(Icons.email_outlined),
                    message: '수신 메일 5건 중 광고 및 스팸 메일 3건을 정리했어요.'),
                BackgroundTaskMessage(
                    icon: const Icon(Icons.edit_calendar_outlined),
                    message: '메일에서 찾은 일정 2건을 캘린더에 추가했어요.'),
                BackgroundTaskMessage(
                    icon: const Icon(Icons.file_copy_outlined),
                    message: '메일함에서 전자세금계산서를 PDF 파일로 변환하여 구글 드라이브에 저장했어요.'),
              ]
          ),
          BackgroundTaskViewer(
              backgroundTaskMessages: [
                BackgroundTaskMessage(
                    icon: const Icon(Icons.email_outlined),
                    message: '수신 메일 5건 중 광고 및 스팸 메일 3건을 정리했어요.'),
              ]
          ),],
      ),
    );
  }
}
