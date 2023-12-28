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
  const GetFreeBusy({super.key});

  @override
  GetFreeBusyState createState() => GetFreeBusyState();
}

class GetFreeBusyState extends State<GetFreeBusy> {
  final AssistantController assistantController = Get.find();
  AuthController authController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

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
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    Map<String, dynamic>? arguments = toolCall?.function.arguments;
    String? ttsString = toolCall?.tts;
    ttsController.playTTS(ttsString ?? '');
    //Map<String, dynamic>? arguments = {"timeMin":"2023-12-14T15:00:00+09:00", "timeMax": "2023-12-14T17:00:00+09:00"};
    String? timeMin = arguments?['timeMin'];
    String? timeMax = arguments?['timeMax'];
    return Expanded(
      child: Container(
        width: 400.w,
        padding: EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${findBusyOrNot(timeMin)}에서',
                style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            Text('${findBusyOrNot(timeMax)} 까지',
                style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: RichText(
                  softWrap: true,
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${authController.name}님의 일정은 다음과 같아요!',
                      style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
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
      ),
    );
  }
}
