import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class DescribeUserQuery extends StatefulWidget {
  @override
  DescribeUserQueryState createState() => DescribeUserQueryState();
}

class DescribeUserQueryState extends State<DescribeUserQuery> {
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
    String? query = arguments?['query'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 0, 10.h),
          child: query != null
              ? Text(query, style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700))
              : const Text(''),
        ),
        Container(
          height: 150.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          color: Colors.white,
          child: TextFormField(
            style: textTheme().displayLarge!.copyWith(color: Colors.black),
            minLines: 1,
            maxLines: 5,
            controller: textController,
            decoration: const InputDecoration(hintText: '커리비에게 요청사항', border: InputBorder.none),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            width: 400.w,
            child: ElevatedButton(
              onPressed: () {
                recorderController.setTranscription(textController.text);
              },
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Color(0xff8B2CF5),
                backgroundColor: Color(0xff8B2CF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child:
                  Text('요청하기', style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
            ))
      ],
    );
  }
}
