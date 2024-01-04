import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/tts_controller.dart';
import '../../Calendar/methods/function_event_date.dart';
import '../../Class/class_my_event.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Dialog/widget/schedule_widget.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class InsertEvent extends StatefulWidget {
  const InsertEvent({super.key});

  @override
  InsertEventState createState() => InsertEventState();
}

class InsertEventState extends State<InsertEvent> {
  RecorderController recorderController = Get.find();
  final AssistantController assistantController = Get.find();
  TtsController ttsController = Get.find<TtsController>();
  String? eventId = '';

  @override
  Widget build(BuildContext context) {
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    Map<String, dynamic>? arguments = toolCall?.function.arguments;
    String? ttsString = toolCall?.tts;
    ttsController.playTTS(ttsString ?? '');
    Event event = Event.fromMap(arguments !);
    //Event event = Event(eventId : 'ddd', summary: 'hihihihi', startTime: '2019-02-23T14:00:00+09:00', endTime: '2019-02-23T14:00:00+09:00');

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.w,30.h,10.w,20.h),
          child: Text('다음 일정을 추가할게요!',
              style: textTheme().bodySmall?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )),
        ),
        ScheduleWidget(myEvent : event),
        if (assistantController.status.value != 'in_progress')
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              width:400.w,
              child: ElevatedButton(onPressed: (){
                recorderController.setTranscription('delete');
              },style: ElevatedButton.styleFrom(
                surfaceTintColor: Color(0xff8B2CF5),
                backgroundColor: Color(0xff8B2CF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ), child: Text('확인',style: textTheme().bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,color:Colors.white
              )
              ),)
          )
      ],
    );
  }
}