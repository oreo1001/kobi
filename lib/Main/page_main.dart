import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kobi/Calendar/page_calendar.dart';
import 'package:kobi/Controller/appointment_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Main/microphone_button.dart';

import '../Assistant/Class/API_response.dart';
import '../Assistant/Class/assistant_enum.dart';
import '../Assistant/Class/assistant_response.dart';
import '../Assistant/Class/step_details.dart';
import '../Assistant/ResponseMethod/response_method.dart';
import '../Assistant/ResponseWidgets/create_email.dart';
import '../Assistant/ResponseWidgets/delete_event.dart';
import '../Assistant/ResponseWidgets/describe_user_query.dart';
import '../Assistant/ResponseWidgets/establish_strategy.dart';
import '../Assistant/ResponseWidgets/get_free_busy.dart';
import '../Assistant/ResponseWidgets/insert_event.dart';
import '../Assistant/ResponseWidgets/message_creation.dart';
import '../Assistant/ResponseWidgets/multiple_choice_query.dart';
import '../Assistant/ResponseWidgets/patch_event.dart';
import '../Assistant/page_assistant.dart';
import '../Class/class_my_event.dart';
import '../Controller/assistant_controller.dart';
import '../Controller/recorder_controller.dart';
import '../Controller/tts_controller.dart';
import '../Dialog/delete_dialog.dart';
import '../Dialog/event_dialog.dart';
import '../Dialog/update_event_dialog.dart';
import '../Mail/page_mail.dart';
import '../User/page_user.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../function_firebase_message.dart';
import '../function_http_request.dart';
import '../in_app_notification/in_app_notification.dart';

class MainPage extends StatefulWidget {
  MainPage(this.pageIndex,{super.key});
  int pageIndex;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Recorder 의존성 주입
  RecorderController recorderController = Get.put(RecorderController());
  // Tts 의존성 주입
  TtsController ttsController = Get.put(TtsController());
  // 캘린더 Appointment 의존성
  AppointmentController appointmentController = Get.put(AppointmentController());
  //메일
  MailController mailController = Get.put(MailController());

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

  int _selectedIndex = 2;
  final List <Widget> _pageList =  [
    AssistantPage(),
    CalendarPage(),
    MailPage(),
    const UserPage(),
  ];

  void _handleMessage(RemoteMessage message) {
    Map <String, dynamic> data = message.data;
    setState(() {
      _selectedIndex = 2;
    });
    String type = data['type'];
    print('test');
    switch (type) {
      case 'insert_event':
        showEventDialog(MyEvent.fromMap(data));
        appointmentController.updateAppointmentFromMap(message.data);
        break;
      case 'update_event':
        showUpdateEventDialog(MyEvent.fromMap(jsonDecode(data["before_event"])), MyEvent.fromMap(jsonDecode(data["after_event"])));
        break;
      case 'delete_event':
        showDeleteDialog(MyEvent.fromMap(data));
        break;
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _pageList.removeAt(0);
        _pageList.insert(0, AssistantPage(key: UniqueKey()));
      }
      if (index == 1) {
        // delete previous page
        _pageList.removeAt(1);
        _pageList.insert(1, CalendarPage(key: UniqueKey()));
      }
      if (index == 2) {
        _pageList.removeAt(2);
        _pageList.insert(2, MailPage(key: UniqueKey()));
      }
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    _selectedIndex = widget.pageIndex;
    if (Platform.isAndroid) {
      initializeAndroidForegroundMessaging(_handleMessage);
    }
    if (Platform.isIOS) {
      initializeIosForegroundMessaging(_handleMessage);
    }
    setupInteractedMessage(_handleMessage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Obx(() {
              List<String> transcription = recorderController.transcription;
              List<dynamic> responseWidgets = recorderController.responseWidgets;
              bool transcriptionChanged = !const ListEquality().equals(previousTranscription, transcription);
              /// mainPage 안의 Obx를 다시 실행시키기 위한 변수 :
              bool mainPageBuilder = recorderController.mainPageBuilder.value;
              print(mainPageBuilder);

              print('@@@@@@@@@@@@@@@@@@@@ Obx 내부 @@@@@@@@@@@@@@@@@@@@');
              print('transcription : $transcription');
              print('responseWidgets : $responseWidgets');

              if (responseWidgets.isNotEmpty) {
                Future.delayed(Duration.zero).then((_) {
                  InAppNotification.show(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child : recorderController.responseWidgets.last
                      ),
                      duration: const Duration(seconds: 60), context: context);
                  recorderController.responseWidgets.removeLast();
                });
              } else {
                Future.delayed(Duration.zero).then((_) {
                  InAppNotification.dismiss(context: context);
                });
              }

              /// BE 로 요청 보내는 조건
              if (transcriptionChanged && readyToRequest(transcription)) {
                previousTranscription = List.from(transcription);
                Future.delayed(Duration.zero, () {
                  requestToBackEnd(transcription);
                });
              }
              return const SizedBox();}),
            Flexible(
              child: Center(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pageList
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MicroPhoneButton(),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.black,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail_outlined,
            ),
            label: 'mail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'myInfo',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void requestToBackEnd(List<String> transcription) async {
    Map<String, dynamic> apiResponseMap = await sendToBackEnd(transcription);

    print('@@@ apiResponseMap : $apiResponseMap @@@');

    /// #2. BackEnd에서 받은 응답을 각각 이 Widget(assistantResponse) / assistantController에 저장
    assistantController.loadAssistantFromJson(apiResponseMap);
    assistantController.printAll();

    assistantResponse.fromJson(apiResponseMap);
    assistantResponse.printAll();

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
      recorderController.responseWidgets.add(const MessageCreationUI(index: 0,));


    } else {
      /// toolCalls의 길이만큼 transcription을 초기화
      int toolCallsLength = assistantResponse.stepDetails!.toolCalls!.length;
      recorderController.transcription = RxList( List.generate(toolCallsLength, (index) => ''));

      for (int i = 0 ; i < toolCallsLength ; i++) {
        String? type = assistantResponse.stepDetails?.toolCalls?[i].function.name;

        print('@@@ 응답 후 type : $type @');

        if (type == AssistantFunction.createEmail.value) {
          recorderController.responseWidgets.add(CreateEmail(index: i,));
        } else if (type == AssistantFunction.describeUserQuery.value) {
          recorderController.responseWidgets.add(DescribeUserQuery(index: i,));
        } else if (type == AssistantFunction.multipleChoiceQuery.value) {
          recorderController.responseWidgets.add(MultipleChoiceQuery(index: i,));
        } else if (type == AssistantFunction.insertEvent.value) {
          recorderController.responseWidgets.add(InsertEvent(index: i,));
        } else if (type == AssistantFunction.patchEvent.value) {
          recorderController.responseWidgets.add(PatchEvent(index: i,));
        } else if (type == AssistantFunction.deleteEvent.value) {
          recorderController.responseWidgets.add(DeleteEvent(index: i,));
        } else if (type == AssistantFunction.getFreeBusy.value) {
          recorderController.responseWidgets.add(GetFreeBusy(index: i,));
          if (assistantResponse.status == 'in_progress') {
            recorderController.setTranscription('OK');
          }
        } else if (type == AssistantFunction.establishStrategy.value) {
          recorderController.responseWidgets.add(EstablishStrategy(index: i,));
          if (assistantResponse.status == 'in_progress') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              recorderController.setTranscription('ok');
            });
          }
        }
      }
    }

    recorderController.toggleMainPageBuilder();
  }
}
