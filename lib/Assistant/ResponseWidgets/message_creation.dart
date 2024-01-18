import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../../../theme.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/tts_controller.dart';
import '../Class/step_details.dart';

class MessageCreationUI extends StatefulWidget {
  final int index;
  const MessageCreationUI({super.key, required this.index});

  @override
  State<MessageCreationUI> createState() => _MessageCreationUIState();
}

class _MessageCreationUIState extends State<MessageCreationUI> {

  final AssistantController assistantController = Get.find();
  TtsController ttsController = Get.find<TtsController>();
  bool isDisposed = false;

  @override
  void dispose() {
  isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (MessageCreation messageCreation in assistantController.stepDetails.value?.messageCreation ?? []) {
      if (!isDisposed) {
        ttsController.playTTS(messageCreation.tts);
      }
    }
    List<MessageCreation> messageCreationList = assistantController.stepDetails.value?.messageCreation ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        messageCreationList.isEmpty? Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
          child: WrappedKoreanText(testMessage,style: textTheme().bodySmall!.copyWith(fontSize: 16.sp)),
        ):Container(),
        for (MessageCreation messageCreation in messageCreationList)
          WrappedKoreanText(
            messageCreation.text['value'].toString(),
            style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}

String testMessage = '테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.테스트 메시지 입니다.';