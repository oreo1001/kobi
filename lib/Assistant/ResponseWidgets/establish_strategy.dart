import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../Controller/assistant_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../theme.dart';

class EstablishStrategy extends StatefulWidget {

  final int index;

  const EstablishStrategy({ super.key, required this.index});

  @override
  EstablishStrategyState createState() =>EstablishStrategyState();
}

class EstablishStrategyState extends State<EstablishStrategy> {
  final AssistantController assistantsController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  void dispose() {
    ttsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadingAnimationWidget.inkDrop(
            size: 100.sp, color: Color(0xff8B2CF5),
          ),
          SizedBox(height: 20.h),
          RichText(
              softWrap: true, text: TextSpan(children:[
            TextSpan(
              text: '커리비는 생각하는 중',
              style: textTheme().bodyMedium!.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            WidgetSpan(
              child: SizedBox(
                width: 5.w,
              ),
            ),
            WidgetSpan(child: AnimatedTextKit(
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
        ],
      );
  }
}