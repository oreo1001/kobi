import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Controller/recorder_controller.dart';

class MicroPhoneButton extends StatelessWidget {
  MicroPhoneButton({super.key});

  RecorderController recorderController = Get.put(RecorderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isRecording = recorderController.isRecording.value;
      bool waitingForResponse = recorderController.waitingForResponse.value;

      return AnimatedScale(
      scale: isRecording ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: 70.w,
        height: 70.h,
        child: waitingForResponse == true ? FloatingActionButton(
            shape: const CircleBorder(),
            heroTag : 'waitingResponse',
            onPressed: () {},
          backgroundColor: const Color(0xFFACCCFF),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ) :
        FloatingActionButton(
          shape: const CircleBorder(),
          heroTag : 'microphone',
          backgroundColor: isRecording == true ? Colors.red : const Color(0xFFACCCFF),
          onPressed: () async {
            // toggle recording
            if (isRecording == true) {
              await recorderController.stopRecording();
            } else {
              recorderController.transcription.value = [''];
              recorderController.startRecording();
            }
          },
          child: isRecording ? const Icon(Icons.stop, color: Colors.white,) : const Icon(Icons.mic, size:50, color: Colors.white),),
      ),
    );});
  }
}
