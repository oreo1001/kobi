import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../function_http_request.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class CreateEmail extends StatefulWidget {
  @override
  CreateEmailState createState() => CreateEmailState();
}

class CreateEmailState extends State<CreateEmail> {
  TextEditingController textController = TextEditingController();
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    Map<String, dynamic>? arguments = toolCall?.function.arguments;
    String? ttsString = toolCall?.tts;
    ttsController.playTTS(ttsString ?? '');

    String? emailAddress = arguments?['emailAddress'];
    String title = arguments?['title'] ?? '';
    String body = arguments?['body'] ?? '';
    bool reply = arguments?['reply'] ?? false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w,30.h,10.w,20.h),
                child: WrappedKoreanText('고객님의 상황에 맞게 메일을 작성하였어요. 이대로 보낼까요?',
                    style: textTheme().bodySmall?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  border: Border.all(
                    width: 1.w,
                    color: Colors.grey.shade200,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: 10.w),
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.w),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text('받는사람',
                                style:
                                textTheme().bodySmall?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ))),
                        SizedBox(width: 5.w),
                        Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffD8EAF9),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(13.sp)),
                            ),
                            child: Text(emailAddress!,
                                style: textTheme()
                                    .bodySmall
                                    ?.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ))),
                      ],
                    ),
                    Divider(color: Colors.grey.shade300),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.h,10.h,0,10.h),
                      alignment: Alignment.centerLeft,
                      child: WrappedKoreanText(title,style: textTheme()
                          .bodySmall
                          ?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.h,10.h,0,10.h),
                      alignment: Alignment.centerLeft,
                      child: WrappedKoreanText(body,style: textTheme()
                          .bodySmall
                          ?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // if (assistantController.status.value != 'in_progress')
          Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: 190.w,
                child: ElevatedButton(
                  onPressed: () {
                    recorderController.setTranscription("don't send it");
                  },
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.blueGrey.shade300,
                    backgroundColor: Colors.blueGrey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('취소',
                      style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: 190.w,
                child: ElevatedButton(
                  onPressed: () async {
                    reply = true;
                    await httpResponse(
                        '/email/send', {"reply": reply, "title": title, "body": body, "emailAddress": emailAddress});
                    recorderController.setTranscription('ok');
                  },
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: const Color(0xffACCCFF),
                    backgroundColor: const Color(0xffACCCFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('이대로 보내기',
                      style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                )),
          ],
        )
      ],
    );
  }
}
