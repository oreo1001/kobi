import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Controller/recorder_controller.dart';
import 'package:kobi/Mail/page_send.dart';

import 'class_email.dart';
import '../theme.dart';
import 'methods/function_mail_date.dart';

class ThreadPage extends StatefulWidget {
  ThreadPage(this.thread, {super.key});
  Thread thread;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  RxList<Message> messageList = <Message>[].obs;
  List<bool> isExpandedList = [];
  MailController mailController = Get.find();
  final ScrollController _scrollController = ScrollController();
  RecorderController recorderController = Get.find();
  List<GlobalKey> keys = <GlobalKey>[].obs;
  String sentUsername = '';

  @override
  void initState() {
    super.initState();
    sentUsername = widget.thread.name;
    messageList = widget.thread.messages;
    keys = List<GlobalKey>.generate(messageList.length, (index) => GlobalKey());
    isExpandedList = List.filled(messageList.length, false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 30.h, 0, 10.h),
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
                      child: SizedBox(
                        width: 310.w,
                        child: Text(sentUsername,
                            overflow: TextOverflow.fade,
                            style: textTheme()
                                .displaySmall
                                ?.copyWith(fontSize: 20.sp)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 130.h),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      toggleExpansion(index);
                      // final key = keys[index];
                      // final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
                      // final Offset? position = box?.localToGlobal(Offset.zero);
                      //
                      // if (position != null) {
                      //   _scrollController.animateTo(
                      //     position.dy,
                      //     duration: Duration(seconds: 1),
                      //     curve: Curves.ease,
                      //   );
                      // }
                    },
                    child: Padding(
                      // key: keys[index],
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
                                        : sentUsername,
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
                                      child: Column(
                                        children: [
                                          Text(
                                            (messageList[index]
                                                        .subject
                                                        .trim() ==
                                                    '')
                                                ? '(제목 없음)'
                                                : messageList[index].subject,
                                            style: textTheme()
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: messageList[index]
                                                          .sentByUser
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            messageList[index].body,
                                            style: textTheme()
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: messageList[index]
                                                          .sentByUser
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                          ),
                                        ],
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
                                      child: Column(
                                        children: [
                                          Text(
                                            (messageList[index]
                                                        .subject
                                                        .trim() ==
                                                    '')
                                                ? '(제목 없음)'
                                                : removeNewlines(
                                                    messageList[index].subject),
                                            style: textTheme()
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: messageList[index]
                                                          .sentByUser
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            removeNewlines(
                                                messageList[index].body),
                                            style: textTheme()
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: messageList[index]
                                                          .sentByUser
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
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
            height: 130.h,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10.h,
                ),
                // TextButton(
                //   style: ButtonStyle(
                //       minimumSize: MaterialStateProperty.all<Size>(Size(300.w, 50.h)),
                //       padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(0,0,0,10.h)),
                //       side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey.shade200, width: 2.w)),
                //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.sp)))),
                //   onPressed: () {
                //     recorderController.setTranscription('${widget.currentThread.emailAddress} 메일 주소로 메일 작성해서 보내줄래?');
                //   },
                //   child: Text('커리비에게 답장 추천받기',
                //       style: textTheme().bodySmall?.copyWith(
                //             fontSize: 13.sp,
                //             fontWeight: FontWeight.w400,
                //           )),
                // ),
                // SizedBox(height: 10.h),
                TextButton(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(300.w, 50.h)),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.grey.shade200, width: 2.w)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp)))),
                  onPressed: () {
                    Get.off(() => SendPage());
                  },
                  child: Text(
                    '메일 쓰기',
                    style: textTheme().bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                )
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
