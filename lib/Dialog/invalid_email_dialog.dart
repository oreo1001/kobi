import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInvalidEmailDialog() {
  Get.dialog(
      AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text("이메일을 입력해주세요"),
        content: const SingleChildScrollView(
          child: Text('유효하지 않은 이메일입니다. 다시 확인해 주세요.'),
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