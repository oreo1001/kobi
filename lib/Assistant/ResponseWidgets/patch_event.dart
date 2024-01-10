import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Class/class_my_event.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../Dialog/widget/schedule_widget.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class PatchEvent extends StatefulWidget {

  final int index;

  const PatchEvent({Key? key, required this.index}) : super(key: key);

  @override
  PatchEventState createState() => PatchEventState();
}

class PatchEventState extends State<PatchEvent> {
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  dispose() {
    ttsController.dispose();
    super.dispose();
  }

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

    MyEvent? beforeEvent;
    MyEvent? afterEvent;
    if (beforeEventMap != null) {
      beforeEvent = MyEvent.fromMap(beforeEventMap);
    } else {
      beforeEvent = MyEvent.fromMap(testBeforeEventMap);
    }
    if (afterEventMap != null) {
      afterEvent = MyEvent.fromMap(afterEventMap);
    } else {
      afterEvent = MyEvent.fromMap(testAfterEventMap);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.w,30.h,10.w,20.h),
          child: Text('일정이 다음과 같이 변경되었어요.',
              style: textTheme().bodySmall?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )),
        ),
        ScheduleWidget(myEvent : beforeEvent),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: const Icon(Icons.keyboard_double_arrow_down),
        ),
        ScheduleWidget(myEvent : afterEvent),
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
                surfaceTintColor: const Color(0xffACCCFF),
                backgroundColor: const Color(0xffACCCFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ))
      ],
    );
  }
}
