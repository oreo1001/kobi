import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';
import '../class_email.dart';

Widget expandedMessage(Message message) {
  return message.mimeType == "text/plain"
      ? Container(
          width: 385.w,
          margin: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
          padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 10.h),
          decoration: BoxDecoration(
            color: message.sentByUser
                ? const Color(0xff759CCC)
                : const Color(0xffD8EAF9),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          ),
          child: Column(
            children: [
              Text(
                (message.subject.trim() == '')
                    ? '(제목 없음)'
                    : message.subject,
                style: textTheme().bodySmall?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          message.sentByUser ? Colors.white : Colors.black,
                    ),
              ),
              SizedBox(height: 5.h),
              Linkify(
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(link.url))) {
                    throw Exception('Could not launch ${link.url}');
                  }
                },
                text: message.body,
                style: textTheme().bodySmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color:
                          message.sentByUser ? Colors.white : Colors.black,
                    ),
                linkStyle: textTheme().bodySmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: message.sentByUser ? Colors.white : Colors.red,
                    ),
              ),
            ],
          ),
        )
      : HtmlWidget(
        message.body,
        renderMode: RenderMode.column,
        onTapUrl: (url) {
          Uri goUrl = Uri.parse(url);
          launchUrl(goUrl);
          return false;
        },
        enableCaching: true,
        textStyle: textTheme()
            .bodySmall
            ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
        customWidgetBuilder: (element) {
          if (element.attributes['xml'] == 'bar') {
            return Container();
          }
          if (element.className == 'xml') {
            return Container();
          }
          if (element.className == 'CToWUd') {
            return Container();
          }
          return null;
        },
      );
}
