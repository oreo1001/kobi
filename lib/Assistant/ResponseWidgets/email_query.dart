import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Controller/mail_assistant_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/function_http_request.dart';
import 'package:kobi/in_app_notification/in_app_notification.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../Mail/class_email.dart';
import '../../Mail/page_send.dart';
import '../../theme.dart';

class EmailQuery extends StatefulWidget {
  EmailQuery(this.context,{Key? key}) : super(key: key);
  BuildContext context;

  @override
  EmailQueryState createState() => EmailQueryState();
}

class EmailQueryState extends State<EmailQuery> {
  final textController = TextEditingController();
  final AssistantController assistantController = Get.find();
  MailController mailController = Get.find();
  TtsController ttsController = Get.find<TtsController>();
  bool isDisposed = false;
  String replyEmailAddress = '';

  MailAssistantController mailAssistantController = Get.put(MailAssistantController()); /// TODO : 일단 put으로 해놨는데, 나중에 Get.find()로 바꿔야함

  @override
  void initState() {
    super.initState();
    replyEmailAddress = mailController.threadList[mailController.threadIndex.value].emailAddress;
  }

  @override
  void dispose() {
    isDisposed = true;
    // ttsController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String query = '메일을 어떤 내용으로 써드릴까요?';
    if (!isDisposed) {
      ttsController.playTTS(query);
    }
    return Obx(
      () {
        textController.text = mailAssistantController.transcription.value;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
              child: Center(
                  child: Text(query,
                      style: textTheme().bodyMedium!.copyWith(
                          fontSize: 18.sp, fontWeight: FontWeight.w600)))),
          Container(
            height: 150.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: TextFormField(
              style: textTheme().displayLarge!.copyWith(color: Colors.black),
              minLines: 1,
              maxLines: 5,
              controller: textController,
              decoration: const InputDecoration(
                  hintText: '커리비에게 요청사항', border: InputBorder.none),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              width: 400.w,
              child: ElevatedButton(
                onPressed: () async{
                  InAppNotification.show(
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child : Text('메일을 작성 중이에요 ...', style: textTheme().displaySmall,)
                      ),
                      duration: const Duration(seconds: 60), context: context);
                  Map<String, dynamic> responseMap = await httpResponse('/email/recommend', {
                    "emailAddress": replyEmailAddress,
                    "content" : textController.text
                  });
                  InAppNotification.dismiss(context: widget.context);
                  Get.to(() => SendPage(
                        testMail: TestMail(
                            emailAddress: replyEmailAddress,
                            title: '',
                            body: responseMap['body'],
                            reply: true),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: const Color(0xffACCCFF),
                  backgroundColor: const Color(0xffACCCFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                ),
                child: Text('요청하기',
                    style: textTheme().bodySmall!.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.white)),
              ))
        ],
      );}
    );
  }
}
