import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'class_email.dart';
import '../theme.dart';
import 'methods/function_mail_date.dart';
import 'methods/function_parsing.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage(this.currentThread, {super.key});

  final Thread currentThread;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  List<Message> messageList = [];
  List<bool> isExpandedList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messageList = parsingMessageListFromThread(widget.currentThread.messages);
    isExpandedList = List.filled(messageList.length, false);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpandedList[index] = !isExpandedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.h),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 50.h, 0, 0),
              child: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios, size: 25.sp)),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 3.h),
                      child: Text(' ${widget.currentThread.name} 님과의 대화',
                          style: textTheme()
                              .displaySmall
                              ?.copyWith(fontSize: 20.sp)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => toggleExpansion(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: messageList[index].sentByUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              RichText(
                                maxLines: 1,
                                softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: messageList[index].sentByUser
                                        ? ''
                                        : widget.currentThread.name,
                                    style: textTheme()
                                        .displayMedium
                                        ?.copyWith(fontSize: 16.sp),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 10.w,
                                    ),
                                  ),
                                  TextSpan(
                                      text: threadDateString(
                                          messageList[index].date),
                                      style: textTheme().bodySmall?.copyWith(
                                          color: Colors.grey, fontSize: 10.sp)),
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 10.w,
                                    ),
                                  ),
                                  TextSpan(
                                    text: messageList[index].sentByUser
                                        ? '나'
                                        : '',
                                    style: textTheme()
                                        .displayMedium
                                        ?.copyWith(fontSize: 16.sp),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                          isExpandedList[index]
                              ? Row(
                                  mainAxisAlignment:
                                      messageList[index].sentByUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 280.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: messageList[index].sentByUser
                                            ? const Color(0xff759CCC)
                                            : const Color(0xffD8EAF9),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.sp)),
                                      ),
                                      child: Text(
                                        messageList[index].body,
                                        style: textTheme().bodySmall?.copyWith(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  messageList[index].sentByUser
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      messageList[index].sentByUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 280.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.sp)),
                                        color: messageList[index].sentByUser
                                            ? const Color(0xff759CCC)
                                            : const Color(0xffD8EAF9),
                                      ),
                                      child: Text(
                                        removeNewlines(messageList[index].body),
                                        style: textTheme().bodySmall?.copyWith(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  messageList[index].sentByUser
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)))),
                  onPressed: () {},
                  child: Text('커리비가 추천하는 답장 보내기',
                      style: textTheme().bodySmall?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          )),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('메일 쓰기',
                      style: textTheme().bodySmall?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String removeNewlines(String text) {
    text = text.replaceAll('\r', '').replaceAll('\n', '');
    return text;
  }
}
