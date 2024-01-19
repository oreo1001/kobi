import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Mail/page_thread.dart';
import 'package:kobi/Mail/widgets/mail_room.dart';
import 'package:kobi/Mail/widgets/unread_mark.dart';
import 'package:unicons/unicons.dart';

import '../Loading/loading_widget.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'SendWidgets/send_drawer.dart';
import 'class_email.dart';
import 'methods/function_thread_data.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  MailController mailController = Get.find();
  RxString filter = 'All'.obs;
  RxList<Thread> filterThreadList = <Thread>[].obs;
  RxList<RxInt> unreadList = <RxInt>[].obs;
  RxBool isLongPressed = false.obs;
  RxList<RxBool> selectedItems = List<RxBool>.generate(100, (index) => false.obs).obs; //임시로 100개로 초기화..

  @override
  void initState() {
    super.initState();
    getThread();
  }

  Future getThread() async {
    Map<String, dynamic> responseMap =
        await httpResponse('/email/emailList', {});
    mailController.threadList =
        loadThreadListFromJson(responseMap['emailList']).obs;
    selectedItems = List<RxBool>.generate(mailController.threadList.length, (index) => false.obs).obs;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (mailController.threadList.isEmpty) {
        return const LoadingWidget();
      } else {
        filterThreadList =
            filterThreadListByFilter(mailController.threadList, filter.value).obs;
        var unreadList = unreadMessageIdListsInThreads(filterThreadList);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 100.h,
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  SizedBox(height: 30.h),
                  isLongPressed.value
                      ? Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  isLongPressed.value = !isLongPressed.value;
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                            Text(selectedItems
                                .where((item) => item.value == true)
                                .length
                                .toString()),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                          child: Text(filter.value,
                              style: textTheme()
                                  .displayMedium
                                  ?.copyWith(fontSize: 20.sp)),
                        ),
                ],
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30.h, 0.w, 0),
                  child: IconButton(
                      onPressed: () {
                        mailController.deleteThread(
                            selectedItems, filterThreadList);
                        selectedItems = List<RxBool>.generate(filterThreadList.length-(selectedItems
                            .where((item) => item.value == true)
                            .length), (index) => false.obs).obs;
                      },
                      icon: const Icon(UniconsLine.trash_alt)),
                ),
                Builder(
                  builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(0, 30.h, 10.w, 0),
                    child: IconButton(
                      icon: Icon(Icons.menu, size: 25.sp),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                ),
              ],
            ),
            endDrawer: SendDrawer(filter),
            body: ListView.builder(
              itemCount: filterThreadList.length,
              itemBuilder: (context, index) {
                Thread thread = filterThreadList[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (isLongPressed.value) {
                      selectedItems[index].value = !selectedItems[index].value;
                    } else {
                      filterThreadList.refresh();
                      mailController.findThreadIndex(thread);
                      mailController.readMessage(thread);
                      Get.to(() => ThreadPage(thread));
                      await httpResponse('/email/read', {
                        "messageIdList": unreadList[index]
                      });
                    }
                  },
                  onLongPress: () {
                    isLongPressed.value = !isLongPressed.value;
                    selectedItems[index].value = !selectedItems[index].value;
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Stack(children: [
                      MailRoom(thread, isLongPressed, selectedItems[index]),
                      /// 안 읽은 메일 개수
                      UnreadMark(unreadList[index].length.obs),
                    ]),
                  ),
                );
              },
            ));
      }
    });
  }
}