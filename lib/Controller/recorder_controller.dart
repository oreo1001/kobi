import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Main/siri_wave.dart';
import '../Class/secure_storage.dart';
import '../KEYS.dart';

class RecorderController extends GetxController {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  RxBool isRecording = false.obs;
  Timer? _silenceTimer;
  bool recordingStarted = false;
  RxList<String> transcription = [''].obs;
  RxString prompt = ''.obs;

  RxDouble decibels = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();

    if (Platform.isIOS) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
        AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
    }
    await _recorder.openRecorder();
  }

  Future<void> startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    await _recorder.startRecorder(toFile: '${tempDir.path}/my_recording.mp4');
    decibels.value = 0.0;

    Get.bottomSheet(
      SiriWave(),
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isDismissible: false,
    );
    isRecording.value = true;
    _startMonitoring();
  }

  void _startMonitoring() async {
    recordingStarted = false;
    _silenceTimer = null;

    // stream으로 decibel 정보 받아올 주기 : 100 ms
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    _recorder.onProgress?.listen((event) {
      decibels.value = event.decibels == null ? 0.0 : event.decibels! < 0 ? 0.0 : event.decibels!;

      if (!recordingStarted) {
        if (decibels > 55) recordingStarted = true;
      } else {
        if (decibels < 55) {
          _startSilenceTimer();
        } else {
          _resetSilenceTimer();
        }
      }
    });
  }

  void _startSilenceTimer() {
    if (_silenceTimer != null) return;
    _silenceTimer?.cancel();
    // 0.5초 뒤에 녹음 중지
    _silenceTimer = Timer(const Duration(milliseconds: 1000), () {
      stopRecording();
    });
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = null;
  }

  Future<void> stopRecording() async {
    Get.back();
    await _recorder.stopRecorder();
    isRecording.value = false;
    _resetSilenceTimer();

    setTranscription(await transcribe());
  }

  @override
  void onClose() async {
    _recorder.closeRecorder();
    _silenceTimer?.cancel();
    super.onClose();
  }

  Future<String> transcribe() async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/my_recording.mp4';
    String transcription = await sendToWhisperAPI(filePath, prompt.value);
    return transcription;
  }

  Future<String> sendToWhisperAPI(String filePath, String prompt) async {
    String apiKey = openAIKey;
    // localhost test: flutter localhost == 10.0.2.2
    String apiUrl = 'http://13.209.152.32/stt/returnZero';

    print('-----------------sendToWhisper 안-----------------');
    print('prompt: $prompt');
    // API를 통해 음성 파일을 보내는데 걸리는 시간을 측정
    Stopwatch stopwatch = Stopwatch()..start();

    // Read the audio file into memory as bytes
    List<int> audioBytes = await File(filePath).readAsBytes();

    // Get the mime type for the MP4 file
    // String? mimeType = lookupMimeType(filePath);

    // Create a multipart request
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add headers
    request.headers.addAll({
      'Authorization': 'Bearer $apiKey',
    });

    // Attach the MP4 file
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        audioBytes,
        filename: 'openai.mp4',
        // contentType: MediaType.parse(mimeType!),
      ),
    );
    final storage = SecureStorage();
    request.fields["user"] = await storage.getUserId() ?? '';


    // Add the model parameter
    // request.fields['model'] = 'whisper-1';
    // request.fields['temperature'] = '0';
    // // request.fields['prompt'] = prompt;
    // request.fields['language'] = 'ko';

    // Send the request and get the response
    http.StreamedResponse response = await request.send();

    // Stop the stopwatch
    stopwatch.stop();
    print('API call took ${stopwatch.elapsed}');

    // Parse the response
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      return jsonResponse['text'];
    } else {
      print('Failed to send video to Whisper API: ${response.statusCode}');
      return 'error';
    }
  }

  void setTranscription(String value) {

    for (int i = transcription.length ; i > 0 ; i--) {
      if (transcription[i-1] == '') {
        transcription[i-1] = value;
        break;
      }
    }
  }
}
