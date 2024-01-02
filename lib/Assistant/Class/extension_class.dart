import 'package:flutter/material.dart';

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

  ExtensionLogInfo({required this.date, required this.log});
}

class ExtensionReportInfo {
  ExtensionDescription extensionDescription;
  List<ExtensionLogInfo> extensionLogInfoList;

  ExtensionReportInfo({required this.extensionDescription, required this.extensionLogInfoList});
}