import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../KEYS.dart';

class RecorderController extends GetxController {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  RxBool isRecording = false.obs;
  Timer? _silenceTimer;
  bool recordingStarted = false;
  RxList<String> transcription = [''].obs;
  RxString prompt = ''.obs;

  static const kSampleRate = 16000;
  static const kNumChannels = 1;
  // late Snowboy detector;
  final FlutterSoundRecorder _micRecorder = FlutterSoundRecorder();
  StreamController? _recordingDataController;
  StreamSubscription? _recordingDataSubscription;


  @override
  void onInit() async {
    super.onInit();
    await _initRecorder();
    // await initPlatformState();
    // await startDetection();

    print('recorder_controller.dart onInit() 시 transcription 값 : $transcription');
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
    print('녹음 시작 : startRecording()');
    isRecording.value = true;
    _startMonitoring();
  }

  void _startMonitoring() async {
    recordingStarted = false;
    _silenceTimer = null;

    // stream으로 decibel 정보 받아올 주기 : 100 ms
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    _recorder.onProgress?.listen((event) {
      double decibels = event.decibels ?? 0;
      print('decibels: $decibels');

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
    await _recorder.stopRecorder();
    isRecording.value = false;
    _resetSilenceTimer();

    // TODO : 삭제해야 함
    // AudioPlayer audioPlayer = AudioPlayer();
    // Directory tempDir = await getTemporaryDirectory();
    // audioPlayer.play(DeviceFileSource('${tempDir.path}/my_recording.mp4'));

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
    String apiUrl = 'https://api.openai.com/v1/audio/transcriptions';

    print('prompt: $prompt');

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

    // Add the model parameter
    request.fields['model'] = 'whisper-1';
    request.fields['temperature'] = '0';
    // request.fields['prompt'] = prompt;
    request.fields['language'] = 'ko';

    // Send the request and get the response
    http.StreamedResponse response = await request.send();

    // Parse the response
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      print('Response: $jsonResponse');
      return jsonResponse['text'];
    } else {
      print('Failed to send video to Whisper API: ${response.statusCode}');
      return 'error';
    }
  }

  void setTranscription(String value) {
    print('setTranscription 이전 값 : $transcription');

    for (int i = transcription.length ; i > 0 ; i--) {
      transcription[i-1] = value;
    }
    print('setTranscription 이후 값 : $transcription');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // final String modelPath = await copyModelToFilesystem("jarvis.umdl");
  //   final String modelPath = await copyModelToFilesystem("hi_embla.pmdl");
  //   // Create detector object and prepare it
  //   detector = Snowboy();
  //   await detector.prepare(modelPath);
  //   detector.hotwordHandler = hotwordHandler;
  //   // await configureAudioSession();
  // }

  // // Copy model from asset bundle to temp directory on the filesystem
  // static Future<String> copyModelToFilesystem(String filename) async {
  //   final String dir = (await getTemporaryDirectory()).path;
  //   final String finalPath = "$dir/$filename";
  //   if (await File(finalPath).exists() == true) {
  //     // Don't overwrite existing file
  //     return finalPath;
  //   }
  //   ByteData bytes = await rootBundle.load("assets/$filename");
  //   final buffer = bytes.buffer;
  //   await File(finalPath).writeAsBytes(
  //       buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  //   return finalPath;
  // }
  //
  // // Function to invoke when hotword is detected
  // void hotwordHandler() async {
  //   // Play sound
  //   Audio beep = Audio.load('assets/ding.wav');
  //   await beep.play();
  //   await beep.dispose();
  //   print("Hotword detected!");
  //   await startRecording();
  // }
  //
  // Future<void> configureAudioSession() async {
  //   final session = await AudioSession.instance;
  //   await session.configure(AudioSessionConfiguration(
  //     avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
  //     avAudioSessionCategoryOptions:
  //     AVAudioSessionCategoryOptions.defaultToSpeaker |
  //     AVAudioSessionCategoryOptions.allowBluetooth,
  //     //     AVAudioSessionCategoryOptions.duckOthers,
  //     // avAudioSessionMode: AVAudioSessionMode.spokenAudio,
  //     avAudioSessionMode: AVAudioSessionMode.defaultMode,
  //     avAudioSessionRouteSharingPolicy:
  //     AVAudioSessionRouteSharingPolicy.defaultPolicy,
  //     avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
  //     androidAudioAttributes: const AndroidAudioAttributes(
  //       contentType: AndroidAudioContentType.speech,
  //       flags: AndroidAudioFlags.none,
  //       usage: AndroidAudioUsage.voiceCommunication,
  //     ),
  //     androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
  //     androidWillPauseWhenDucked: true,
  //   ));
  //   await session.setActive(true);
  // }
  //
  // Future<void> startDetection() async {
  //   // Prep recording session
  //   await _micRecorder.openRecorder();
  //
  //   // Create recording stream
  //   _recordingDataController = StreamController<Food>();
  //   _recordingDataSubscription =
  //       _recordingDataController?.stream.listen((buffer) {
  //         // When we get data, feed it into Snowboy detector
  //         if (buffer is FoodData) {
  //           Uint8List copy = new Uint8List.fromList(buffer.data!);
  //           // print("Got audio data (${buffer.data.lengthInBytes} bytes");
  //           // detector.detect(copy);
  //         }
  //       });
  //
  //   // Start recording
  //   await _micRecorder.startRecorder(
  //       toStream: _recordingDataController!.sink as StreamSink<Food>,
  //       codec: Codec.pcm16,
  //       numChannels: kNumChannels,
  //       sampleRate: kSampleRate);
  // }
  //
  // Future<void> stopDetection() async {
  //   await _micRecorder.stopRecorder();
  //   await _micRecorder.closeRecorder();
  //   await _recordingDataSubscription?.cancel();
  //   await _recordingDataController?.close();
  // }
}
