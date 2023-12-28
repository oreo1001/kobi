import 'package:animated_text_kit/animated_text_kit.dart';
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
  MessageCreationState createState() => MessageCreationState();
}

class MessageCreationState extends State<MessageCreationUI> {
  final AssistantController assistantController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  Widget build(BuildContext context) {
    for (MessageCreation messageCreation in assistantController.stepDetails.value?.messageCreation ?? []) {
      ttsController.playTTS(messageCreation.tts ?? '');
    }
    return Container(
      width: 400.w,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (MessageCreation messageCreation in assistantController.stepDetails.value?.messageCreation ?? [])
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  messageCreation.text['value'].toString(),
                  textStyle: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              isRepeatingAnimation: false,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          // if(assistantsController.status.value =='completed')
          // Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          //     width:400.w,
          //     child: ElevatedButton(onPressed: (){
          //       currentScreen = CalendarApp();
          //       Get.offAllNamed('/main');
          //     }, child: Text('돌아가기',style: textTheme().bodySmall!.copyWith(
          //         fontWeight: FontWeight.w700,color:Colors.white
          //     )
          //     ),style: ElevatedButton.styleFrom(
          //       surfaceTintColor: Color(0xff8B2CF5),
          //       backgroundColor: Color(0xff8B2CF5),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //     ),)
          // )
        ],
      ),
    );
  }
}
