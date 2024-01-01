import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Mail/methods/match_email_to_color.dart';
import 'package:kobi/Mail/page_thread.dart';
import 'package:kobi/Mail/widgets/mail_room.dart';
import 'package:kobi/Mail/widgets/unread_mark.dart';

import 'class_email.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'methods/function_parsing.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {

  static Future getMail() async {
    Map<String, dynamic> responseMap =
    await httpResponse('/email/emailList', {});
    var emailList = loadThreadListFromJson(responseMap['emailList']);
    return emailList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'));
          } else {
            var threadList = snapshot.data as List<Thread>;

            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  toolbarHeight: 100.h,
                  automaticallyImplyLeading: false,
                  title: Column(
                    children: [
                      SizedBox(height : 10.h),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w,0,0,0),
                        child: Text('메일',
                            style: textTheme()
                                .displayMedium
                                ?.copyWith(fontSize: 40.sp)),
                      ),
                    ],
                  )
              ),
              body: ListView.builder(
                itemCount: threadList.length,
                itemBuilder: (context, index) {
                  final thread = threadList[index];
                  final messageList = parsingMessageListFromThread(thread.messages);
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.to(() => ThreadPage(thread));
                      httpResponse('/email/read', {"threadId": thread.threadId, "messageId": messageList[messageList.length - 1].messageId});
                      setState(() {});
                    },
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                      child: Stack(
                        children: [
                          mailRoom(matchEmailToColor(thread.emailAddress), thread, messageList),
                          /// 안 읽은 메일 개수
                          unreadMark(messageList)]
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
