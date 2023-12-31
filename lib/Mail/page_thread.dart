import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'class_email.dart';
import '../theme.dart';
import 'function_mail_date.dart';
import 'function_parsing.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage(this.currentThread, {super.key});
  final Thread currentThread;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  List<Message> messageList = [];
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    messageList = parsingMessageListFromThread(widget.currentThread.messages);
    isExpandedList = List.filled(messageList.length, false);
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpandedList[index] = !isExpandedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Column(
          children: [
            Text(' ${widget.currentThread.name} 님과의 대화',
                style: textTheme().displayMedium?.copyWith(fontSize: 15.sp)),
            // Text(messageList[0].subject,
            //     style: textTheme()
            //         .displaySmall
            //         ?.copyWith(fontSize: 13.sp, color: Colors.blueGrey)),
          ],
        )),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return InkWell(
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
                                  messageList[index].sentByUser ? '나   ' : widget.currentThread.name,
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
                                text: threadDateString(messageList[index].date),
                                style: textTheme()
                                    .bodySmall
                                    ?.copyWith(fontSize: 10.sp)),
                          ])),
                      isExpandedList[index]
                          ? Text(
                              messageList[index].body,
                              style: textTheme().bodySmall?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blueGrey.shade700,
                                  ),
                            )
                          : Text(
                              removeNewlines(messageList[index].body),
                              style: textTheme().bodySmall?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blueGrey.shade700,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                      const Divider(),
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
