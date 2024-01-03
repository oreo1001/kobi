import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/tts_controller.dart';
import '../Class/step_details.dart';

class MessageCreationUI extends StatefulWidget {
  const MessageCreationUI({super.key});

  @override
  State<MessageCreationUI> createState() => _MessageCreationUIState();
}

class _MessageCreationUIState extends State<MessageCreationUI> {

  @override
  Widget build(BuildContext context) {

    final AssistantController assistantController = Get.find();
    TtsController ttsController = Get.find<TtsController>();

    for (MessageCreation messageCreation in assistantController.stepDetails.value?.messageCreation ?? []) {
      ttsController.playTTS(messageCreation.tts);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (MessageCreation messageCreation in assistantController.stepDetails.value?.messageCreation ?? [])
          Text(
            messageCreation.text['value'].toString(),
            style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}
