import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/auth_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class GetFreeBusy extends StatefulWidget {
  final int index;
  const GetFreeBusy({super.key, required this.index});
  @override
  GetFreeBusyState createState() => GetFreeBusyState();
}

class GetFreeBusyState extends State<GetFreeBusy> {
  final AssistantController assistantController = Get.find();
  AuthController authController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  void initState() {
    ttsController.dispose();
    super.initState();
  }

  String? findBusyOrNot(String? exDate) {
    if (exDate == null) {
      return null;
    } else {
      DateTime utcDate = DateTime.parse(exDate).toUtc();
      DateTime kstDate = utcDate.add(Duration(hours: 9));
      String formattedDate = DateFormat('M월 d일 a h:mm').format(kstDate);
      return formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    // Map<String, dynamic>? arguments = toolCall?.function.arguments;
    // String? ttsString = toolCall?.tts;
    // ttsController.playTTS(ttsString ?? '');
    // String timeMin;
    // String timeMax;
    // if(arguments==null){
    //   timeMin = "2024-01-14T15:00:00+09:00";
    //   timeMax = "2024-01-15T17:00:00+09:00";
    // }else{
    //   timeMin = arguments['timeMin'];
    //   timeMax = arguments['timeMax'];
    // }
    return Container(
      width: 600.w,
      padding: EdgeInsets.fromLTRB(0.w, 0, 0, 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
            child: RichText(
                softWrap: true,
                text: TextSpan(children: [
                  TextSpan(
                    text: '${authController.name}님의 일정을 조회 하고 있어요',
                    style: textTheme().bodyMedium!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                  WidgetSpan(
                    child: SizedBox(
                      width: 5.w,
                    ),
                  ),
                  WidgetSpan(
                      child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        '...',
                        textStyle: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    isRepeatingAnimation: true,
                    displayFullTextOnTap: false,
                  )),
                ])),
          ),
        ],
      ),
    );
  }
}
