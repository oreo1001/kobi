import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Assistant/ResponseWidgets/email_query.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Mail/page_send.dart';
import 'package:unicons/unicons.dart';

import '../../Controller/mail_assistant_controller.dart';
import '../../in_app_notification/in_app_notification.dart';
import '../../theme.dart';
import '../class_email.dart';

class MyAnimatedButton extends StatefulWidget {
  @override
  _MyAnimatedButtonState createState() => _MyAnimatedButtonState();
}

class _MyAnimatedButtonState extends State<MyAnimatedButton> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _animateFade;
  List<Message> messageList = [];

  MailController mailController = Get.find();
  MailAssistantController mailAssistantController = Get.put(MailAssistantController()); /// TODO : 일단 put으로 해놨는데, 나중에 Get.find()로 바꿔야함

  @override
  initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 500), value: 1.0)
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateFade =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    super.initState();
    messageList = mailController.threadList[mailController.threadIndex.value].messages;
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int countMyMail(List<Message> messageList) {
    return messageList.where((message) => message.sentByUser).length;
  }

  animate() {
    if (isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget buttonAssistant() {
    return FadeTransition(
      opacity: _animateFade,
      child: Container(
        width:150.w,
        child: FloatingActionButton(
          onPressed: (){
            _animationController.value = 1.0;
            if(countMyMail(messageList)<1){
              Get.snackbar(
                "AI 답장을 사용하시려면",
                "고객님이 보낸 메일이 있어야 합니다.",
                snackPosition: SnackPosition.TOP,
              );
            }
            else{
              mailRequiredNotification();
            }
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          tooltip: 'Add',
          heroTag: 'add',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w,0,5.w,0),
                child: Icon(Icons.assistant_outlined,color: Colors.black),
              ),
              Text('커리비에게 맡겨보기',style: textTheme().bodySmall?.copyWith(color:Colors.black),)
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonDirect() {
    return FadeTransition(
      opacity: _animateFade,
      child: Container(
        width: 130.w,
        child: FloatingActionButton(
          onPressed: (){
            _animationController.value = 1.0;
            Get.to(() => SendPage());
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          tooltip: 'Edit',
          heroTag: 'edit',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w,0,5.w,0),
                child: const Icon(UniconsLine.edit,color: Colors.black),
              ),
              Text('직접 작성하기',style: textTheme().bodySmall?.copyWith(color:Colors.black),)
            ],
          ),
        ),
      ),
    );
  }

  Widget toggle() {
    return Container(
      width:100.w,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        onPressed: animate,
        heroTag: 'toggle',
        tooltip: 'Toggle',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _animateFade.value * pi,
                  child: Opacity(
                    opacity: _animateFade.value < 0.5
                        ? 1.0-(_animateFade.value)
                        : 1.0 - (_animateFade.value - 0.5),
                    child: Icon(_animateFade.value < 0.5 ? UniconsLine.envelope : Icons.close , color: Colors.black,)),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w,0,10.w,2.h),
              child: Text('메일쓰기',style: textTheme().bodySmall?.copyWith(color:Colors.black),),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _animateIcon.value * 130.0,
            0.0,
          ),
          child: buttonAssistant(),
        ),
        SizedBox(height:10.h),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _animateIcon.value * 65.0,
            0.0,
          ),
          child: buttonDirect(),
        ),
        SizedBox(height:10.h),
        toggle(),
      ],
    );
  }
  void mailRequiredNotification(){
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
            child : Column(
                children: [
                  EmailQuery(context),
                  Obx(() {
                    bool isRecording = mailAssistantController.isRecording.value;

                    return InkWell(
                      onTap: () async {
                        // toggle recording
                        if (isRecording == true) {
                          await mailAssistantController.stopRecording();
                        } else {
                          mailAssistantController.transcription.value = '';
                          mailAssistantController.startRecording();
                        }

                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRecording == true ? Colors.red : const Color(0xFFACCCFF),
                            border: Border.all(
                                color: Colors.grey[100]!),
                          ),
                          child: isRecording ? const Icon(Icons.stop, size: 50, color: Colors.white,) : const Icon(Icons.mic, size:50, color: Colors.white)),
                    );
                  }
                  )
                ]),
          ),
          duration: const Duration(seconds: 60), context: context);
    });
  }
}

String testBody = '''양대지수 모두 하락. 전일 삼성전자 어닝 쇼크 여파에 하락했던 국내 증시는 오늘도 반도체주 약세 지속. 외국인이 전기전자 업종 중심 매물 출회 확대하면서 SK하이닉스도 장중 -3%대 하락. 더불어 2차전지주도 하락하며 지수 전반 하방 압력 확대. 원화 약세폭 확대. 미국 국채금리 상승, CPI 경계감에 따른 안전 선호 심리 강화 그럼 그 시간에 뵙겠습니당
      -----Original Message-----
          From: "오동근"<ohsimon77@naver.com>
    To: "오동근[졸업생 / 화학과]"<oreo1001@hufs.ac.kr>;
    Cc:
    Sent: 2024-01-10 (수) 13:36:12 (GMT+09:00)
    Subject: Re: 안녕하세요 동근님 1월 14일 오후 7시에 뵙고 싶습니다.


    15일 오후 3시에도 추가미팅을 잡고싶은데 괜찮으신가요?
    -----Original Message-----';''';