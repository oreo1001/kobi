import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/HomeWidgets/extension_report.dart';

import '../Loading/loading_widget.dart';
import '../function_http_request.dart';
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
    return background;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getBackground(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.hasError) {
              return const LoadingWidget();
            } else {
              var background = snapshot.data as Background;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white70),
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
                          child: Text('hi')),
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
