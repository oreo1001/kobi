import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

    //Map<String, dynamic>? arguments = {"reply": false, "emailAddress": "douglas@primer.kr", "title": "Meeting Request for Next Wednesday", "body": "Dear 권도균 대표님,I hope this message finds you well. I am reaching out to schedule an appointment for us to meet next Wednesday at 5pm. Please let me know if this time works for you or if we need to find an alternative.Looking forward to your confirmation.Best regards,김정원"};
    String? emailAddress = arguments?['emailAddress'];
    String title = arguments?['title'] ?? '';
    String body = arguments?['body'] ?? '';
    bool reply = arguments?['reply'] ?? false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 10.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(color: Colors.lightBlue.shade300, width: 9.w)),
            borderRadius: BorderRadius.all(Radius.circular(9.sp)), // 오른쪽 위 둥근 border
          ),
          width: 400.w,
          height: 300.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              if (title != null)
                Text(title, style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
              SizedBox(height: 5.h),
              if (emailAddress != null)
                Text('To : $emailAddress',
                    style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp)),
              SizedBox(height: 15.h),
              Text(body ?? '', style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 13.sp))
            ],
          ),
        ),
        Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: 190.w,
                child: ElevatedButton(
                  onPressed: () {
                    recorderController.transcription.value = "don't send it";
                  },
                  child: Text('취소',
                      style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.blueGrey.shade300,
                    backgroundColor: Colors.blueGrey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: 190.w,
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> responseMap = await httpResponse(
                        '/email/send', {"reply": reply, "title": title, "body": body, "emailAddress": emailAddress});
                    print("이메일 응답 받았냐? : " + responseMap.toString());
                    recorderController.transcription.value = 'ok';
                  },
                  child: Text('이대로 보내기',
                      style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.lightBlue.shade300,
                    backgroundColor: Colors.lightBlue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }
}
