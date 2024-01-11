import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../../Controller/assistant_controller.dart';
import '../../Controller/recorder_controller.dart';
import '../../Controller/tts_controller.dart';
import '../../function_http_request.dart';
import '../../theme.dart';
import '../Class/step_details.dart';

class CreateEmail extends StatefulWidget {
  final int index;
  const CreateEmail({Key? key, required this.index}) : super(key: key);

  @override
  CreateEmailState createState() => CreateEmailState();
}

class CreateEmailState extends State<CreateEmail> {
  TextEditingController textController = TextEditingController();
  final AssistantController assistantController = Get.find();
  RecorderController recorderController = Get.find();
  TtsController ttsController = Get.find<TtsController>();

  @override
  void dispose() {
    ttsController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToolCall? toolCall = assistantController.stepDetails.value?.toolCalls?[0];
    Map<String, dynamic>? arguments = toolCall?.function.arguments;
    String? ttsString = toolCall?.tts;
    ttsController.playTTS(ttsString ?? '');

    String emailAddress;
    String title;
    String body;
    bool reply;

    if(arguments==null){
      reply = false;
      emailAddress = 'jungwon01234512345@gmail.com';
      title = '[미래에셋증권] [2024 Outlook] 글로벌 소프트웨어, 24년 투자전략: 생성AI 실전편 “고민하면 늦어요”';
      body = testBody;
    }else{
      reply = arguments['reply'] ?? false;
      emailAddress = arguments['emailAddress'] ?? '';
      title = arguments['title'] ?? '(제목 없음)';
      body = arguments['body'] ?? '';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.w,10.h,0.w,10.h),
                child: WrappedKoreanText('고객님의 상황에 맞게 메일을 작성하였어요. 이대로 보낼까요?',
                    style: textTheme().bodySmall?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  border: Border.all(
                    width: 1.w,
                    color: Colors.grey.shade200,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 0.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.w),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text('받는사람',
                                style:
                                textTheme().bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ))),
                        SizedBox(width: 5.w),
                        Container(
                          width: 240.w,
                            height: 40.h,
                            padding: EdgeInsets.fromLTRB(10.w,10.h,0,10.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffD8EAF9),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(13.sp)),
                            ),
                            child: Text(emailAddress,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme()
                                    .bodySmall
                                    ?.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ))),
                      ],
                    ),
                    Divider(color: Colors.grey.shade300),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.h,10.h,0,10.h),
                      alignment: Alignment.centerLeft,
                      child: WrappedKoreanText(title,style: textTheme()
                          .bodySmall
                          ?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.h,10.h,0,10.h),
                      alignment: Alignment.centerLeft,
                      child: WrappedKoreanText(body,style: textTheme()
                          .bodySmall
                          ?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // if (assistantController.status.value != 'in_progress')
          Row(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0,0,5.w,0),
                width: 150.w,
                child: ElevatedButton(
                  onPressed: () {
                    recorderController.setTranscription("don't send it");
                  },
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.blueGrey.shade300,
                    backgroundColor: Colors.blueGrey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('취소',
                      style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(5.w,0,0,0),
                width: 150.w,
                child: ElevatedButton(
                  onPressed: () async {
                    reply = true;
                    await httpResponse(
                        '/email/send', {"reply": reply, "title": title, "body": body, "emailAddress": emailAddress});
                    recorderController.setTranscription('ok');
                  },
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: const Color(0xffACCCFF),
                    backgroundColor: const Color(0xffACCCFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('이대로 보내기',
                      style: textTheme().bodySmall!.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                )),
          ],
        )
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