import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Class/class_my_event.dart';
import '../Controller/event_controller.dart';

void showDeleteDialog() {
  EventController eventController = Get.find<EventController>();
  MyEvent event = eventController.deleteEvent.value;
  Get.dialog(
      AlertDialog(
        title: Text(event.summary),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('일정이 삭제되었습니다.'),
              Text('설명: ${event.description}'),
              Text('시작 시간: ${event.startTime}'),
              Text('종료 시간: ${event.endTime}'),
              Text('장소: ${event.location}'),
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
      )
  );
}