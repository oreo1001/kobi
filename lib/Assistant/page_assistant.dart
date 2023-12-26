import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:kobi/Assistant/ResponseWidgets/default.dart';
import 'package:kobi/Assistant/ResponseWidgets/response_animation.dart';
import 'package:kobi/Controller/recorder_controller.dart';

import '../Controller/assistant_controller.dart';
import '../Controller/tts_controller.dart';
import '../function_http_request.dart';
import 'Class/API_response.dart';
import 'Class/assistant_enum.dart';
import 'Class/assistant_response.dart';
import 'ResponseWidgets/completed_page.dart';
import 'ResponseWidgets/create_email.dart';
import 'ResponseWidgets/delete_event.dart';
import 'ResponseWidgets/describe_user_query.dart';
import 'ResponseWidgets/establish_strategy.dart';
import 'ResponseWidgets/get_free_busy.dart';
import 'ResponseWidgets/insert_event.dart';
import 'ResponseWidgets/message_creation.dart';
import 'ResponseWidgets/multiple_choice_query.dart';
import 'ResponseWidgets/patch_event.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State< AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State< AssistantPage> {

  // Recorder 의존성 주입
  RecorderController recorderController = Get.put(RecorderController());
  // Tts 의존성 주입
  TtsController ttsController = Get.put(TtsController());

  // 화면에 보여줄 Widget 저장
  Widget currentWidget = DefaultResponse();

  // 이전의 transcription 값 저장
  String previousTranscription = '';

  // 이 widget에서 사용할 AssistantResponse
  AssistantResponse assistantResponse =
  AssistantResponse(assistantId: '',
      threadId: '',
      runId: '',
      stepId: '',
      status: 'initial',
      type: '');

  // 저장할 AssistantController
  AssistantController assistantController = Get.put(AssistantController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Column(children: [
        Obx(() {
          // transcription 의 변화를 감지하여 currentScreen을 변경
          String transcription = recorderController.transcription.value;
          print('transcription 값 : $transcription');
          print('previousTranscription 값 : $previousTranscription');
          print('requestToBackEnd 호출 여부 : ${transcription != previousTranscription}');

          if (transcription != previousTranscription) {
            previousTranscription = transcription;
            requestToBackEnd(transcription);
          }
          return SizedBox();}),
        SlideFromLeftAnimation(child: currentWidget)]);
  }

  void requestToBackEnd(String transcription) async {
    Map<String, dynamic> apiResponseMap = await sendToBackEnd(transcription);

    /// BackEnd에서 받은 응답을 각각 이 Widget(assistantResponse) / assistantController에 저장
    assistantController.loadAssistantFromJson(apiResponseMap);
    assistantResponse.fromJson(apiResponseMap);

    /// BackEnd에서 받은 응답을 가지고 화면에 보여줄 Widget을 결정
    switchWidget();
  }


  /// #1. 사용자의 입력을 받고 BackEnd에 전달
  Future<Map<String, dynamic>> sendToBackEnd(String transcription) async {
    Map<String, dynamic> apiRequestMap;
    Map<String, dynamic> apiResponseMap;

    if (assistantResponse.status != 'in_progress') {
      /// assistant 에게 처음 요청

      apiResponseMap =
      await httpResponse('/assistant/run', {'userRequest': transcription});
    } else {
      /// assistant 사용 중에 요청

      var toolCall = assistantResponse.stepDetails?.toolCalls?[0];
      if (toolCall != null) {
        /// before step이 tool_calls 일때
        apiRequestMap = APIResponse(
          assistantId: assistantResponse.assistantId,
          runId: assistantResponse.runId,
          stepId: assistantResponse.stepId,
          beforeType: assistantResponse.type,
          threadId: assistantResponse.threadId,
          functionResponses: {
            "tool_outputs": [
              ToolOutput(toolCallId: toolCall.id,
                  name: toolCall.function.name,
                  output: {"message": transcription})
                  .toJson()
            ]
          },
        ).toJson();
      } else {
        /// before step 이 message_creation 일때
        apiRequestMap = APIResponse(
          assistantId: assistantResponse.assistantId,
          runId: assistantResponse.runId,
          stepId: assistantResponse.stepId,
          beforeType: assistantResponse.type,
          threadId: assistantResponse.threadId,
        ).toJson();
      }
      apiResponseMap = await httpResponse('/assistant/step', apiRequestMap);
    }

    return apiResponseMap;
  }

  /// #3. BackEnd에서 받은 응답을 가지고 currentScreen을 변경
  void switchWidget() {
    setState(() {
    String responseWidgetType = assistantResponse.type;
    if (responseWidgetType == 'message_creation') {
      currentWidget = MessageCreationUI();
    } else {
      String? type = assistantResponse.stepDetails?.toolCalls?[0].function.name;

      if (type == AssistantFunction.createEmail.value) {
        currentWidget = CreateEmail();
      } else if (type == AssistantFunction.describeUserQuery.value) {
        currentWidget = DescribeUserQuery();
      } else if (type == AssistantFunction.multipleChoiceQuery.value) {
        currentWidget = const MultipleChoiceQuery();
      } else if (type == AssistantFunction.insertEvent.value) {
        currentWidget = InsertEvent();
      } else if (type == AssistantFunction.patchEvent.value) {
        currentWidget = PatchEvent();
      } else if (type == AssistantFunction.deleteEvent.value) { /// OK!
        currentWidget = const DeleteEvent();
      } else if (type == AssistantFunction.getFreeBusy.value) { /// OK!
        currentWidget = const GetFreeBusy();
        if (assistantResponse.status == 'in_progress') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            requestToBackEnd("ok");
          });
        }
      } else if (type == AssistantFunction.establishStrategy.value) {
        currentWidget = const EstablishStrategy();
        if (assistantResponse.status == 'in_progress') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            requestToBackEnd("ok");
          });
        }
      } else {
        currentWidget = CompletedPage();
      }
    }
    });
  }
}