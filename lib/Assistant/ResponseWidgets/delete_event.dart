import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/tts_controller.dart';
import '../../Calendar/function_event_date.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class DeleteEvent extends StatefulWidget {
  const DeleteEvent({super.key});

  @override
  DeleteEventState createState() => DeleteEventState();
}

class DeleteEventState extends State<DeleteEvent> {
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
    String? summary = arguments?['summary'];
    String? description = arguments?['description'];
    String? startTime = eventKSTDate(arguments?['startTime']);
    String? endTime = eventKSTDate(arguments?['endTime']);
    String? location = arguments?['location'];

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('다음 일정을 삭제 했어요',style: textTheme()
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp)),
          Container(
            margin: EdgeInsets.fromLTRB(10.w,20.h,10.w,10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.all(Radius.circular(9.sp)), // 오른쪽 위 둥근 border
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
                  width:330.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(summary!=null)
                        Text(summary,
                            style: textTheme()
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
                      SizedBox(height: 5.h),
                      if(location!=null)
                        Text(location,
                            style: textTheme()
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
                      RichText(maxLines: 1,
                          softWrap: true, text: TextSpan(children:[
                            TextSpan(
                                text: startTime,
                                style: textTheme().displaySmall?.copyWith(fontSize: 12.sp)
                            ),
                            WidgetSpan(
                              child: SizedBox(
                                width: 5.w,
                              ),
                            ),
                            TextSpan(
                                text: '-',
                                style: textTheme().displaySmall?.copyWith(fontSize: 12.sp,overflow: TextOverflow.ellipsis)
                            ),
                            WidgetSpan(
                              child: SizedBox(
                                width: 5.w,
                              ),
                            ),
                            TextSpan(
                                text: endTime,
                                style: textTheme().displaySmall?.copyWith(fontSize: 12.sp,overflow: TextOverflow.ellipsis)
                            ),
                          ])),
                      SizedBox(height: 10.h),
                      if(description!=null)
                        Text(description,style: textTheme().bodySmall!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12.sp
                        )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (assistantController.status.value == 'in_progress')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              width:400.w,
              child: ElevatedButton(onPressed: (){
                recorderController.transcription.value = 'delete';
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