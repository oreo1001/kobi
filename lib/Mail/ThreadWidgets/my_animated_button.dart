import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Mail/page_send.dart';

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
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
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
            Get.to(() => SendPage(testMail: TestMail(emailAddress :'jungwon01234512345@gmail.com',
                title :'[미래에셋증권] [2024 Outlook] 글로벌 소프트웨어, 24년 투자전략: 생성AI 실전편 “고민하면 늦어요”',body:testBody,reply: true),));
            //recorderController.setTranscription('${widget.thread.emailAddress} 메일 주소로 메일 작성해서 보내줄래?');
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
        width:130.w,
        child: FloatingActionButton(
          onPressed: (){
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
                child: Icon(Icons.edit,color: Colors.black),
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
                    child: Icon(_animateFade.value < 0.5 ? Icons.mail : Icons.close , color: Colors.black,)),
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