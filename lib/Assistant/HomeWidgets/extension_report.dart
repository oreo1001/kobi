import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/HomeWidgets/active_extension.dart';

import '../Class/extension_class.dart';
import 'extension_log.dart';

class ExtensionReport extends StatelessWidget {
  const ExtensionReport({super.key, required this.extensionReportInfo});

  final ExtensionReportInfo extensionReportInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
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
        children: [
          ActiveExtension(extensionDescription: extensionReportInfo.extensionDescription,),
          Column(
            children: extensionReportInfo.extensionLogInfoList.map((extensionLogInfo) =>
            ExtensionLog(extensionLogInfo: extensionLogInfo,)).toList()
        ),]
      ),
    );
  }
}
