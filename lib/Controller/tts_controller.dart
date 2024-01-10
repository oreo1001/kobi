import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsController extends GetxController {
  FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    flutterTts.stop().then((_) {super.dispose();});

  }

  @override
  void onInit() async {
    super.onInit();
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setVoice({"name": "ko-kr-x-ism-local"});
  }

  Future<void> playTTS(String text) async {
    await flutterTts.speak(text);
  }
}
