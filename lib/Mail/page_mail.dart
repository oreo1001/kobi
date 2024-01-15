import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Mail/page_thread.dart';
import 'package:kobi/Mail/widgets/mail_room.dart';
import 'package:kobi/Mail/widgets/unread_mark.dart';

import '../Loading/loading_widget.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'class_email.dart';
import 'methods/function_thread_data.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  AuthController authController = Get.find();
  MailController mailController = Get.find();
  String name = '';
  String email = '';
  String photoUrl = '';
  RxString filter = 'WonMoMeeting 메일함'.obs;
  RxList<Thread> filterThreadList = <Thread>[].obs;
  RxList<RxInt> unreadList = <RxInt>[].obs;
  RxBool isLongPressed = false.obs;
  RxList<RxBool> selectedItems = List<RxBool>.generate(100, (index) => false.obs).obs; //임시로 100개로 초기화..

  @override
  void initState() {
    super.initState();
    name = authController.name.value;
    email = authController.email.value;
    photoUrl = authController.photoUrl.value;
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
                                  ?.copyWith(fontSize: 23.sp)),
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
                      icon: const Icon(Icons.delete)),
                ),
                Builder(
                  builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(0, 30.h, 10.w, 0),
                    child: IconButton(
                      icon: Icon(Icons.menu, size: 30.sp),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                ),
              ],
            ),
            endDrawer: Drawer(
              width: 300.w,
              backgroundColor: Colors.white,
              elevation: 0,
              child: ListView(
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                children: [
                  SizedBox(height: 30.h),
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30.sp),
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.fill,
                        scale: 0.3,
                      ), // Text(key['title']),
                    ),
                    title: Text(name,
                        style: textTheme().bodySmall?.copyWith(
                            fontSize: 15.sp, color: Colors.grey.shade800)),
                    subtitle: Text(email,
                        style: textTheme().bodySmall?.copyWith(
                            fontSize: 12.sp, color: Colors.grey.shade500)),
                  ),
                  SizedBox(height: 17.h),
                  ListTile(
                    leading: Icon(Icons.folder_outlined, size: 25.sp),
                    title: Text('WonMoMeeting 메일함',
                        style: textTheme().bodySmall?.copyWith(
                            fontSize: 15.sp, color: Colors.grey.shade800)),
                    onTap: () {
                      filter.value = 'WonMoMeeting 메일함';
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                      leading: Icon(Icons.folder_outlined, size: 25.sp),
                      title: Text('전체 메일함',
                          style: textTheme().bodySmall?.copyWith(
                              fontSize: 15.sp, color: Colors.grey.shade800)),
                      onTap: () {
                        filter.value = '전체 메일함';
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: Icon(Icons.folder_outlined, size: 25.sp),
                    title: Text('프로모션 메일함',
                        style: textTheme().bodySmall?.copyWith(
                            fontSize: 15.sp, color: Colors.grey.shade800)),
                    onTap: () {
                      filter.value = '프로모션 메일함';
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
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
