import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class DescribeUserQuery extends StatefulWidget {
  final int index;

  const DescribeUserQuery({Key? key, required this.index}) : super(key: key);

  @override
  DescribeUserQueryState createState() => DescribeUserQueryState();
}

class DescribeUserQueryState extends State<DescribeUserQuery> {
  final textController = TextEditingController();
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();
  bool isDisposed = false;

  @override
  void dispose() {
  isDisposed = true;
    // ttsController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    Map<String, dynamic>? arguments = toolCall?.function.arguments;
    String? ttsString = toolCall?.tts;
    if (!isDisposed) {
      ttsController.playTTS(ttsString ?? '');
    }

    String query;
    if(arguments==null){
      query = '제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목';
    }
    else {
      query = arguments['query'];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
          child:
              Center(child: Text(query, style: textTheme().bodyMedium!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600)))
        ),
        Container(
          height: 150.h,
          //margin: EdgeInsets.symmetric(horizontal: 10.w),
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
                surfaceTintColor: const Color(0xffACCCFF),
                backgroundColor: const Color(0xffACCCFF),
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
