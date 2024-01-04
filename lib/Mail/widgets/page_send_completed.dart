import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SentCompleted extends StatelessWidget {
  const SentCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body : Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('메일을 성공적으로 보냈습니다.'),
        TextButton(onPressed: (){ Get.offNamed('/main');  }, child: Text('홈으로 돌아가기'))
      ],
    )));
  }
}