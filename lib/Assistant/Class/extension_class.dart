import 'package:flutter/material.dart';

import '../../Class/class_my_event.dart';
import '../../Mail/class_email.dart';

class ExtensionDescription {
  Icon icon = const Icon(Icons.mail_outlined);
  Color iconColor = const Color(0xFFACCCFF);
  String message = '';

  ExtensionDescription({
    required this.icon,
    required this.iconColor,
    required this.message
  });
}
class ExtensionLogInfo {
  String date = '';
  String log = '';
  final TestMail? testMail;
  final MyEvent? event;

  ExtensionLogInfo({required this.date, required this.log, this.testMail, this.event});
}

class ExtensionReportInfo {
  ExtensionDescription extensionDescription;
  List<ExtensionLogInfo> extensionLogInfoList;

  ExtensionReportInfo({required this.extensionDescription, required this.extensionLogInfoList});
}