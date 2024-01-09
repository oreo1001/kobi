import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Mail/methods/match_email_to_color.dart';
import 'package:kobi/Mail/page_thread.dart';
import 'package:kobi/Mail/widgets/mail_room.dart';
import 'package:kobi/Mail/widgets/unread_mark.dart';

import '../function_http_request.dart';
import '../theme.dart';
import 'class_email.dart';
import 'methods/function_parsing.dart';

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
  String filter = 'WonMoMeeting 메일함';

  @override
  void initState() {
    super.initState();
    name = authController.name.value;
    email = authController.email.value;
    photoUrl = authController.photoUrl.value;
    mailController.getThread();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (mailController.threadList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
          } else {
            var filterThreadList = filterThreadListByFilter(mailController.threadList, filter);
            mailController.threadList = filterThreadList.obs;
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  toolbarHeight: 100.h,
                  automaticallyImplyLeading: false,
                  title: Column(
                    children: [
                      SizedBox(height : 30.h),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w,0,0,0),
                        child: Text(filter,
                            style: textTheme()
                                .displayMedium
                                ?.copyWith(fontSize: 23.sp)),
                      ),
                    ],
                  ),
                actions: <Widget>[
                  Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsets.fromLTRB(0,30.h,10.w,0),
                      child: IconButton(
                        icon: Icon(Icons.menu,size: 30.sp),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
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
                  padding: EdgeInsets.fromLTRB(10.w,0,10.w,0),
                  children: [
                    SizedBox(height:30.h),
                    ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30.sp),
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.fill,
                          scale: 0.3,
                        ), // Text(key['title']),
                      ),
                      title: Text(name,style: textTheme().bodySmall?.copyWith(fontSize: 15.sp, color: Colors.grey.shade800)),
                      subtitle: Text(email,style: textTheme().bodySmall?.copyWith(fontSize: 12.sp, color: Colors.grey.shade500)),
                    ),
                    SizedBox(height:17.h),
                    ListTile(
                      leading: Icon(Icons.folder_outlined, size: 25.sp),
                      title: Text('WonMoMeeting 메일함',style:textTheme().bodySmall?.copyWith(fontSize: 15.sp, color: Colors.grey.shade800)),
                      onTap: () {
                        setState(() {
                          filter = 'WonMoMeeting 메일함';
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.folder_outlined, size: 25.sp),
                      title: Text('전체 메일함',style:textTheme().bodySmall?.copyWith(fontSize: 15.sp, color: Colors.grey.shade800)),
                      onTap: () {
                        setState(() {
                          filter = '전체 메일함';
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.folder_outlined, size: 25.sp),
                      title: Text('프로모션 메일함',style:textTheme().bodySmall?.copyWith(fontSize: 15.sp, color: Colors.grey.shade800)),
                      onTap: () {
                        setState(() {
                          filter = '프로모션 메일함';
                        });
                      },
                    ),
                    // 추가적인 프로필 정보를 여기에 넣으세요.
                  ],
                ),
              ),
              body: ListView.builder(
                itemCount: filterThreadList.length,
                itemBuilder: (context, index) {
                  Thread thread = filterThreadList[index];

                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      mailController.threadIndex.value = index;
                      Get.to(() => const ThreadPage());
                      httpResponse('/email/read', {"messageIdList": unreadMessageIdList(thread.messages)});
                      setState(() {});
                    },
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                      child: Stack(
                        children: [
                          mailRoom(matchEmailToColor(thread.emailAddress), thread, thread.messages),
                          /// 안 읽은 메일 개수
                          unreadMark(thread.messages)]
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
