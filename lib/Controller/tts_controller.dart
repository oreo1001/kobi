import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsController extends GetxController {
  FlutterTts flutterTts = FlutterTts();

  @override
  void onInit() async {
    super.onInit();
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.7);
    List<dynamic> voices = await flutterTts.getVoices;
    for (dynamic voice in voices) {
      print(voice);
    }
    await flutterTts.setVoice({"name": "ko-kr-x-ism-local"});
  }

  Future<void> playTTS(String text) async {
    await flutterTts.speak(text);
  }
}
