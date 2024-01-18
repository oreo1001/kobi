import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class MultipleChoiceQuery extends StatefulWidget {
  final int index;

  const MultipleChoiceQuery({super.key, required this.index});

  @override
  State<MultipleChoiceQuery> createState() => _MultipleChoiceQueryState();
}

class _MultipleChoiceQueryState extends State<MultipleChoiceQuery> {
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();
  String selectedItem = '';
  Map<String, dynamic>? arguments;
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    arguments = toolCall?.function.arguments;
    String? ttsString = toolCall?.tts;
    if (!isDisposed) {
      ttsController.playTTS(ttsString ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    String query;
    List<dynamic> options;
    if (arguments == null) {
      query = testQuery;
      options = testOptions;
    } else {
      query = arguments?['query'];
      options = arguments?['options'];
    }
    print(query);
    print(options);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0.w, 10.h, 0, 0.h),
          child: WrappedKoreanText(query,
              style: textTheme()
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
              width: 350.w,
              height: 70.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: selectedItem == options[index]
                      ? Colors.lightBlue.shade200
                      : Colors.white,
                  backgroundColor: selectedItem == options[index]
                      ? Colors.lightBlue.shade200
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedItem = options[index];
                  });
                },
                child: Center(
                    child: Text(options[index],
                        textAlign: TextAlign.center,
                        style: textTheme().bodySmall!.copyWith(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),maxLines: 2,overflow: TextOverflow.ellipsis,)),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
          width: 400.w,
          child: ElevatedButton(
            onPressed: () {
              recorderController.setTranscription(selectedItem);
            },
            child: Text('이대로 보내기',
                style: textTheme().bodySmall!.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              surfaceTintColor: const Color(0xffACCCFF),
              backgroundColor: const Color(0xffACCCFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String testQuery =
    '이것은 multiple user query 입니다.이것은 multiple user query 입니다.이것은 multiple user query 입니다.이것은 multiple user query 입니다.이것은 multiple user query 입니다.이것은 multiple user query 입니다.';
List<dynamic> testOptions = [
  'testtesttesttest1',
  'testtesttesttest2',
  'testtesttesttest3',
  'testtesttesttest4',
  'testtesttesttest5',
  'testesstsststesteststststststststststststststststststststststst1',
  'testesstsststesteststststststststststststststststststststststst1',
  'testesstsststesteststststststststststststststststststststststst1',
  'testesstsststesteststststststststststststststststststststststst1',
  'testesstsststesteststststststststststststststststststststststst1'
];

String testQuery2 = "커리를 선택해주세요.";
List<dynamic> testOptions2 = [
  '안녕하세요 반갑습니다 저는 야채커리를 좋아합니다.',
  '안녕하세요 반갑습니다 저는 고추커리를 좋아합니다.',
  '안녕하세요 반갑습니다 저는 양파커리를 좋아합니다.',
  '안녕하세요 반갑습니다 저는 피망커리를 좋아합니다.',
  '안녕하세요 반갑습니다 저는 고기커리를 좋아합니다.안녕하세요 반갑습니다 저는 고기커리를 좋아합니다.안녕하세요 반갑습니다 저는 고기커리를 좋아합니다.안녕하세요 반갑습니다 저는 고기커리를 좋아합니다.안녕하세요 반갑습니다 저는 고기커리를 좋아합니다.',
];

