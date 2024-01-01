import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Calendar/methods/function_event_date.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class InsertEvent extends StatefulWidget {
  @override
  InsertEventState createState() => InsertEventState();
}

class InsertEventState extends State<InsertEvent> {
  TextEditingController textController = TextEditingController();
  RecorderController recorderController = Get.find();
  final AssistantController assistantController = Get.find();
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
    //Map<String, dynamic>? arguments =  {"location" : "성동구","description": "hi hi djsodpgjsdpgojdsopgjosdgjposjdpgojposdgjopsdjopgjsdopjg","summary": "Meet with 권도균 대표님", "startTime": "2023-12-14T17:00:00+09:00", "endTime": "2023-12-14T18:00:00+09:00"};
    String? summary = arguments?['summary'];
    String? description = arguments?['description'];
    String? startTime = eventKSTDate(arguments?['startTime']);
    String? endTime = eventKSTDate(arguments?['endTime']);
    String? location = arguments?['location'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('아래 일정을 추가할게요!', style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp)),
        Container(
          margin: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 10.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(9.sp)), // 오른쪽 위 둥근 border
          ),
          width: 400.w,
          height: 170.h,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 13.w, 0),
                height: 200.h,
                width: 7.w,
                decoration: BoxDecoration(
                  color: Color(0xffC665FD),
                  borderRadius: BorderRadius.circular(5.sp),
                ),
              ),
              SizedBox(
                width: 330.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (summary != null)
                      Text(summary,
                          style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
                    SizedBox(height: 5.h),
                    if (location != null)
                      Text(location,
                          style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
                    RichText(
                        maxLines: 1,
                        softWrap: true,
                        text: TextSpan(children: [
                          TextSpan(text: startTime, style: textTheme().displaySmall?.copyWith(fontSize: 12.sp)),
                          WidgetSpan(
                            child: SizedBox(
                              width: 5.w,
                            ),
                          ),
                          TextSpan(
                              text: '-',
                              style:
                                  textTheme().displaySmall?.copyWith(fontSize: 12.sp, overflow: TextOverflow.ellipsis)),
                          WidgetSpan(
                            child: SizedBox(
                              width: 5.w,
                            ),
                          ),
                          TextSpan(
                              text: endTime,
                              style:
                                  textTheme().displaySmall?.copyWith(fontSize: 12.sp, overflow: TextOverflow.ellipsis)),
                        ])),
                    SizedBox(height: 10.h),
                    if (description != null)
                      Text(description,
                          style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            width: 400.w,
            child: ElevatedButton(
              onPressed: () {
                recorderController.setTranscription('ok');
              },
              style: ElevatedButton.styleFrom(
                surfaceTintColor: const Color(0xff8B2CF5),
                backgroundColor: const Color(0xff8B2CF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child:
                  Text('확인', style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
            ))
      ],
    );
  }
}
