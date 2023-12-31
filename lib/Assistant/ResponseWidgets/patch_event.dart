import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Class/class_my_event.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class PatchEvent extends StatefulWidget {
  @override
  PatchEventState createState() => PatchEventState();
}

class PatchEventState extends State<PatchEvent> {
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  Widget build(BuildContext context) {
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    String? ttsString = toolCall?.tts;
    ttsController.playTTS(ttsString ?? '');
    Map<String, dynamic>? beforeEventMap = toolCall?.function.arguments['before_event'];
    Map<String, dynamic>? afterEventMap = toolCall?.function.arguments['after_event'];
    Map<String, dynamic>? testBeforeEventMap = {
      "location": "성동구",
      "description": "hi hi djsodpgjsdpgojdsopgjosdgjposjdpgojposdgjopsdjopgjsdopjg",
      "summary": "Meet with 권도균 대표님",
      "startTime": "2023-12-14T17:00:00+09:00",
      "endTime": "2023-12-14T18:00:00+09:00"
    };
    Map<String, dynamic>? testAfterEventMap = {
      "location": "성동구",
      "description": "권도균 대표님과 주말에 하는 즐거운 미팅",
      "summary": "Meet with 권도균 대표님",
      "startTime": "2023-12-14T18:00:00+09:00",
      "endTime": "2023-12-14T19:00:00+09:00"
    };

    Event? beforeEvent;
    Event? afterEvent;
    if (beforeEventMap != null) {
      beforeEvent = Event.fromMap(beforeEventMap);
    } else {
      beforeEvent = Event.fromMap(testBeforeEventMap);
    }
    if (afterEventMap != null) {
      afterEvent = Event.fromMap(afterEventMap);
    } else {
      afterEvent = Event.fromMap(testAfterEventMap);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('일정을 다음과 같이 수정할게요.', style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp)),
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
                    // if(beforeEvent.summary!=null)
                    Text(beforeEvent.summary,
                        style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
                    SizedBox(height: 5.h),
                    if (beforeEvent.location != null)
                      Text(beforeEvent.location!,
                          style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
                    RichText(
                        maxLines: 1,
                        softWrap: true,
                        text: TextSpan(children: [
                          TextSpan(
                              text: beforeEvent.startTime, style: textTheme().displaySmall?.copyWith(fontSize: 12.sp)),
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
                              text: beforeEvent.endTime,
                              style:
                                  textTheme().displaySmall?.copyWith(fontSize: 12.sp, overflow: TextOverflow.ellipsis)),
                        ])),
                    SizedBox(height: 10.h),
                    if (beforeEvent.description != null)
                      Text(beforeEvent.description!,
                          style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: pi / 2,
          child: Image(
            image: AssetImage('assets/images/arrow.jpg'),
            width: 40.w,
          ),
        ),
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
                    // if(beforeEvent.summary!=null)
                    Text(afterEvent.summary,
                        style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
                    SizedBox(height: 5.h),
                    if (afterEvent.location != null)
                      Text(afterEvent.location!,
                          style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
                    RichText(
                        maxLines: 1,
                        softWrap: true,
                        text: TextSpan(children: [
                          TextSpan(
                              text: afterEvent.startTime, style: textTheme().displaySmall?.copyWith(fontSize: 12.sp)),
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
                              text: afterEvent.endTime,
                              style:
                                  textTheme().displaySmall?.copyWith(fontSize: 12.sp, overflow: TextOverflow.ellipsis)),
                        ])),
                    SizedBox(height: 10.h),
                    if (afterEvent.description != null)
                      Text(afterEvent.description!,
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
              child:
                  Text('확인', style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Color(0xff8B2CF5),
                backgroundColor: Color(0xff8B2CF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ))
      ],
    );
  }
}
