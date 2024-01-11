import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Controller/recorder_controller.dart';
import 'package:kobi/Mail/ThreadWidgets/condensed_message.dart';
import 'package:kobi/Mail/ThreadWidgets/expanded_message.dart';
import 'package:kobi/Mail/page_send.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'ThreadWidgets/thread_time.dart';
import 'class_email.dart';
import '../theme.dart';

class ThreadPage extends StatefulWidget {
  ThreadPage(this.thread, {super.key});
  Thread thread;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  // final ScrollOffsetController scrollOffsetController =
  // ScrollOffsetController();
  // final ScrollOffsetListener scrollOffsetListener =
  // ScrollOffsetListener.create();

  MailController mailController = Get.find();
  RecorderController recorderController = Get.find();
  String sentUsername = '';
  RxList<Message> messageList = <Message>[].obs;
  List<bool> isExpandedList = [];
  List<GlobalKey> itemKeys = [];

  @override
  void initState() {
    super.initState();
    sentUsername = widget.thread.name;
    messageList = widget.thread.messages;
    itemKeys = List.generate(messageList.length, (index) => GlobalKey());
    isExpandedList = List.filled(messageList.length, false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: messageList.length - 1);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async{
                      toggleExpansion(index);
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (index == 0 && !isExpandedList[index]) {   // 첫 번째 항목 맨 위로 스크롤
                          itemScrollController.scrollTo(
                            index: index,
                            alignment: 0.0,
                            duration: const Duration(milliseconds: 200),
                          );
                        }
                        else if (index == messageList.length - 1 && !isExpandedList[index]) {// 마지막 항목 맨 아래로 스크롤
                          itemScrollController.scrollTo(
                            index: index,
                            alignment: 0.9,
                            duration: const Duration(milliseconds: 200),
                          );
                        }
                        else {
                          itemScrollController.scrollTo(
                            index: index,
                            alignment: isExpandedList[index] ? 0.1 : 0.5,
                            duration: const Duration(milliseconds: 200),
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          threadTime(messageList[index],sentUsername),
                          isExpandedList[index]
                              ? expandedMessage(messageList[index])
                              : condensedMessage(messageList[index])
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
}
