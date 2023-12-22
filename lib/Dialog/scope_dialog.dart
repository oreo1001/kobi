import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showScopeDialog() {
  Get.dialog(
      AlertDialog(
        title: Text("권한이 필요합니다."),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('권한이 없어서 앱을 실행할 수 없습니다.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("닫기"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      )
  );
}