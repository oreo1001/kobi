import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Assistant/home_widget.dart';
import 'package:kobi/Controller/recorder_controller.dart';
import 'package:kobi/in_app_notification/in_app_notification.dart';

import '../Controller/assistant_controller.dart';
import '../Controller/tts_controller.dart';
import '../function_http_request.dart';
import 'Class/API_response.dart';
import 'Class/assistant_enum.dart';
import 'Class/assistant_response.dart';
import 'Class/step_details.dart';
import 'ResponseMethod/response_method.dart';
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

  // 이전의 transcription 값 저장
  List<String> previousTranscription = [''];

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
  Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Obx(() {
                List<String> transcription = recorderController.transcription;
                bool equal = !const ListEquality().equals(previousTranscription, transcription);

                print('@@@@@@@@@@@@@@@@@@@@ Obx 내부 @@@@@@@@@@@@@@@@@@@@');

                if (recorderController.responseWidgets.isNotEmpty) {
                  Future.delayed(Duration.zero).then((_) {
                    InAppNotification.show(
                        child: Container(margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            width: 400.w,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                            child : recorderController.responseWidgets.last
                        ),
                        duration: const Duration(seconds: 60), context: context);
                    recorderController.responseWidgets.removeLast();
                  });
                }

                /// BE 로 요청 보내는 조건
                if (equal && readyToRequest(transcription)) {
                  previousTranscription = List.from(transcription);
                  Future.delayed(Duration.zero, () {
                    requestToBackEnd(transcription);
                  });
                }
              return const SizedBox();}),
            const HomeWidget()
          ]),
        ),
      );
  }

  void requestToBackEnd(List<String> transcription) async {

    /// TODO
    /// 마이크가 loading으로 변하도록

    Map<String, dynamic> apiResponseMap = await sendToBackEnd(transcription);

    /// #2. BackEnd에서 받은 응답을 각각 이 Widget(assistantResponse) / assistantController에 저장
    assistantController.loadAssistantFromJson(apiResponseMap);
    assistantResponse.fromJson(apiResponseMap);

    /// BackEnd에서 받은 응답을 가지고 화면에 보여줄 Widget을 결정
    switchWidget();
  }


  /// #1. 사용자의 입력을 받고 BackEnd에 전달
  Future<Map<String, dynamic>> sendToBackEnd(List<String> transcription) async {
    Map<String, dynamic> apiRequestMap;
    Map<String, dynamic> apiResponseMap;

    /// 마이크 loading으로 변하도록
    recorderController.waitingForResponse.value = true;

    if (assistantResponse.status != 'in_progress') {
      /// assistant 에게 처음 요청

      apiResponseMap =
      await httpResponse('/assistant/run', {'userRequest': transcription[0]});
    } else {
      /// assistant 사용 중에 요청

      List<ToolCall>? toolCalls = assistantResponse.stepDetails?.toolCalls;
      if (toolCalls != null) {
        /// before step이 tool_calls 일때
        apiRequestMap = APIResponse(
          assistantId: assistantResponse.assistantId,
          runId: assistantResponse.runId,
          stepId: assistantResponse.stepId,
          beforeType: assistantResponse.type,
          threadId: assistantResponse.threadId,
          functionResponses: {
            "tool_outputs": toolCalls.asMap().map((key, value) {
              return MapEntry(key,
                ToolOutput(toolCallId: value.id, name: value.function.name,
                output: {"message": transcription[key]}).toJson());}).values.toList()
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


    /// 마이크 대기 상태로 변하도록
    recorderController.waitingForResponse.value = false;

    return apiResponseMap;
  }

  /// #3. BackEnd에서 받은 응답을 가지고 currentScreen을 변경
  void switchWidget() async {

    /// recorderController의 responseWidgets 초기화
    recorderController.responseWidgets.clear();

    String responseWidgetType = assistantResponse.type;
    if (responseWidgetType == 'message_creation') {
      recorderController.responseWidgets.add(const MessageCreationUI());
    } else {
      /// toolCalls의 길이만큼 transcription을 초기화
      int toolCallsLength = assistantResponse.stepDetails!.toolCalls!.length;
      recorderController.transcription = RxList( List.generate(toolCallsLength, (index) => ''));

      for (int i = 0 ; i < toolCallsLength ; i++) {
        String? type = assistantResponse.stepDetails?.toolCalls?[i].function.name;

        if (type == AssistantFunction.createEmail.value) {
          recorderController.responseWidgets.add(CreateEmail());
        } else if (type == AssistantFunction.describeUserQuery.value) {
          recorderController.responseWidgets.add(DescribeUserQuery());
        } else if (type == AssistantFunction.multipleChoiceQuery.value) {
          recorderController.responseWidgets.add(const MultipleChoiceQuery());
        } else if (type == AssistantFunction.insertEvent.value) {
          recorderController.responseWidgets.add(InsertEvent());
        } else if (type == AssistantFunction.patchEvent.value) {
          recorderController.responseWidgets.add(PatchEvent());
        } else if (type == AssistantFunction.deleteEvent.value) {
          recorderController.responseWidgets.add(const DeleteEvent());
        } else if (type == AssistantFunction.getFreeBusy.value) {
          recorderController.responseWidgets.add(const GetFreeBusy());
          if (assistantResponse.status == 'in_progress') {
              recorderController.setTranscription('OK');
          }
        } else if (type == AssistantFunction.establishStrategy.value) {
          recorderController.responseWidgets.add(const EstablishStrategy());
          if (assistantResponse.status == 'in_progress') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              recorderController.setTranscription('ok');
            });
          }
        }
      }
    }
}}