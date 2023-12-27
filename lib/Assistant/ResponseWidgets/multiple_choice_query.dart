import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class MultipleChoiceQuery extends StatefulWidget {
  const MultipleChoiceQuery({super.key});

  @override
  State<MultipleChoiceQuery> createState() => _MultipleChoiceQueryState();
}

class _MultipleChoiceQueryState extends State<MultipleChoiceQuery> {
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();
  String selectedItem = '';
  Map<String, dynamic>? arguments;

  @override
  void initState() {
    super.initState();
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    arguments = toolCall?.function.arguments ?? {"query": "", "options": []};
    String? ttsString = toolCall?.tts;
    ttsController.playTTS(ttsString ?? '');
  }

  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic>? arguments = {"query":"이거랑 이거중에 뭘 선택하시겠어요?","options":["1번 선택지","2번 선택지","3번 선택지","4번 선택지"]};
    String? query = arguments?['query'];
    List<dynamic> options = arguments?['options'];
    // print(query);
    // print(options);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10.w, 50.h, 0, 0.h),
            child: query != null
                ? Text(query, style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp))
                : Text(''),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  width: 350.w,
                  height: 100.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: selectedItem == options[index] ? Colors.lightBlue.shade200 : Colors.white,
                      backgroundColor: selectedItem == options[index] ? Colors.lightBlue.shade200 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedItem = options[index];
                      });
                    },
                    child: Text(options[index]),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            width: 400.w,
            child: ElevatedButton(
              onPressed: () {
                recorderController.setTranscription(selectedItem);
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
            ),
          ),
        ],
      ),
    );
  }
}
