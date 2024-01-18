import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Controller/recorder_controller.dart';
import 'package:kobi/Mail/ThreadWidgets/condensed_message.dart';
import 'package:kobi/Mail/ThreadWidgets/expanded_message.dart';
import 'package:kobi/Mail/ThreadWidgets/my_animated_button.dart';
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
      //처음에 마지막 인덱스로 이동
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
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30.h),
            child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      toggleExpansion(index);
                      scrollToContainer(index);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.w),
                          child: threadTime(messageList[index], sentUsername),
                        ),
                        isExpandedList[index]
                            ? expandedMessage(messageList[index])
                            : condensedMessage(messageList[index]),
                      ],
                    ),
                  );
                }),
          ),
        ),
        Positioned(bottom:60.h, right:20.w,child: MyAnimatedButton()),
      ],
    );
  }

  void scrollToContainer(int index) {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (index == 0 && !isExpandedList[index]) {
        // 첫 번째 항목 맨 위로 스크롤
        itemScrollController.scrollTo(
          index: index,
          alignment: 0,
          duration: const Duration(milliseconds: 500),
        );
      } else if (index == messageList.length - 1 && !isExpandedList[index]) {
        // 마지막 항목 맨 아래로 스크롤
        itemScrollController.scrollTo(
          index: index,
          alignment: 0.9,
          duration: const Duration(milliseconds: 500),
        );
      } else if(isExpandedList[index]){
        itemScrollController.scrollTo(
          index: index,
          alignment: 0,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }
}
