import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'class_email.dart';
import '../theme.dart';
import 'function_mail_date.dart';
import 'function_parsing.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage(this.currentEmail, {super.key});
  final Email currentEmail;

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  bool isExpanded = false;
  List<Thread> threadList = [];

  @override
  void initState() {
    super.initState();
    threadList = parsingThreadsFromEmail(widget.currentEmail.messages);
  }

  void toggleExpansion(int index) {
    setState(() {
      threadList[index].isExpanded = !threadList[index].isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Column(
          children: [
            Text(' ${widget.currentEmail.name} 님과의 대화',
                style: textTheme().displayMedium?.copyWith(fontSize: 15.sp)),
            Text(threadList[0].subject,
                style: textTheme()
                    .displaySmall
                    ?.copyWith(fontSize: 13.sp, color: Colors.blueGrey)),
          ],
        )),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView.builder(
              itemCount: threadList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => toggleExpansion(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          maxLines: 1,
                          softWrap: true,
                          text: TextSpan(children: [
                            TextSpan(
                              text:
                                  threadList[index].sentByUser ? '나   ' : '상대',
                              style: textTheme()
                                  .displayMedium
                                  ?.copyWith(fontSize: 18.sp),
                            ),
                            WidgetSpan(
                              child: SizedBox(
                                width: 5.w,
                              ),
                            ),
                            TextSpan(
                                text: threadDateString(threadList[index].date),
                                style: textTheme()
                                    .bodySmall
                                    ?.copyWith(fontSize: 10.sp)),
                          ])),
                      threadList[index].isExpanded
                          ? Text(
                              threadList[index].body,
                              style: textTheme().bodySmall?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blueGrey.shade700,
                                  ),
                            )
                          : Text(
                              removeNewlines(threadList[index].body),
                              style: textTheme().bodySmall?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blueGrey.shade700,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                      Divider(),
                    ],
                  ),
                );
              }),
        ));
  }

  String removeNewlines(String text) {
    text = text.replaceAll('\r', '').replaceAll('\n', '');
    return text;
  }
}
