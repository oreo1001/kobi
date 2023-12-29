import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Controller/recorder_controller.dart';
import 'package:siri_wave/siri_wave.dart';

class SiriWave extends StatefulWidget {
  const SiriWave({super.key});

  @override
  State<SiriWave> createState() => _SiriWaveState();
}

class _SiriWaveState extends State<SiriWave> {

  RecorderController recorderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 80.h),
        child: Container(
          height: 100.h,
          width: 200.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black,),
          child: Obx(() {
            double amplitude = recorderController.decibels.value/50;
            amplitude = 1;
            print('siri_wave.dart 에서 amplitude 값 : $amplitude');
            return SiriWaveform.ios9(
              // controller: IOS9SiriWaveformController(
              //   // amplitude: amplitude > 1 ? 1 : amplitude,
              //   amplitude: 1
              // ),
              options: IOS9SiriWaveformOptions(
                height: 100.h,
                width: 200.w
              ),
            );}
          ),
        )
    );
  }
}
