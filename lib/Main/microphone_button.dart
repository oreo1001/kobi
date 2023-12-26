import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kobi/Controller/recorder_controller.dart';

class MicroPhoneButton extends StatelessWidget {
  MicroPhoneButton({super.key});

  RecorderController recorderController = Get.put(RecorderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {return FloatingActionButton(
      heroTag : 'microphone',
      backgroundColor: recorderController.isRecording.value == true ? Colors.red : Colors.amber,
      onPressed: () async {
        // toggle recording
        if (recorderController.isRecording.value == true) {
          await recorderController.stopRecording();
        } else {
          recorderController.startRecording();
        }
      },
      child: recorderController.isRecording.value ? const Icon(Icons.stop) : const Icon(Icons.mic),);});
  }
}
