import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Class/class_my_event.dart';
void showUpdateEventDialog(Event beforeEvent, Event afterEvent) {  //Map<String, dynamic> beforeEvent, Map<String, dynamic> afterEvent
  Get.dialog(
    AlertDialog(
      title: Text('이벤트 업데이트'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('이전 이벤트 정보:'),
            Text('설명: ${beforeEvent.description}'),
            Text('시작 시간: ${beforeEvent.startTime}'),
            Text('종료 시간: ${beforeEvent.endTime}'),
            Text('장소: ${beforeEvent.location}'),
            SizedBox(height: 20), // 간격 추가
            Text('업데이트된 이벤트 정보:'),
            Text('설명: ${afterEvent.description}'),
            Text('시작 시간: ${afterEvent.startTime}'),
            Text('종료 시간: ${afterEvent.endTime}'),
            Text('장소: ${afterEvent.location}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("취소"),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
}
