import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Assistant/AssistantWidgets/background_calendar.dart';
import 'package:kobi/Assistant/AssistantWidgets/blur_container.dart';
import 'package:kobi/Assistant/AssistantWidgets/temp_carousel.dart';
import 'package:kobi/Assistant/AssistantWidgets/voice_carousel.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

import '../Main/page_main.dart';
import '../theme.dart';

class AssistantPage2 extends StatefulWidget {
  const AssistantPage2({super.key});

  @override
  State<AssistantPage2> createState() => _AssistantPage2State();
}

class _AssistantPage2State extends State<AssistantPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 20.h, 15.w, 15.h),
                child: IconButton(
                    onPressed: () {
                      Get.off(() => MainPage(3));
                    },
                    icon: const Icon(Icons.person, color: Color(0xff4A90FF))))
          ]),
          blurContainer('이메일을 카테고리로 자동 분류', '카테고리를 직접 설정할 수도 있어요',
              Icons.sort_by_alpha, Container(height:30.h)),
          SizedBox(height: 30.h),
          blurContainer(
              '이메일로 자동으로 일정 추가',
              '메일을 읽고 내 캘린더에 일정을 추가해줘요',
              Icons.calendar_month,
            Column(
              children: [
                backgroundCalendar('정원과 영화보기', '2024.01.20 22:34', '수정된 일정'),
                backgroundCalendar('정모와 게임하기', '2024.01.21 22:34', '삭제된 일정'),
                backgroundCalendar('하늘과 스키타기', '2024.01.22 22:34', '추가된 일정'),
              ],
            )
          ),
          SizedBox(height: 30.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Text('AI 음성 비서',
                style: textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ),
          CarouselSlider(
            items: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  voiceCarousel('일정 조회', '커리비에게 이번주 일정 물어보기', Icons.schedule),
                  SizedBox(width: 20.w),
                  voiceCarousel('일정 추가', '커리비야 일정 추가해줘', Icons.calendar_today),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  voiceCarousel(
                      '일정 변경', '커리비에게 이번주 일정 변경해달라고 하기', Icons.edit_calendar),
                  SizedBox(width: 20.w),
                  voiceCarousel('일정 삭제', '커리비야 일정 삭제해줘', Icons.delete_forever),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  voiceCarousel('일정 삭제', '커리비야 일정 삭제해줘', Icons.delete_forever),
                  SizedBox(width: 20.w),
                  tempCarousel()
                ],
              ),
            ],
            options: CarouselOptions(
              height: 160.h,
              aspectRatio: 2,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(seconds: 3),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              // onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
