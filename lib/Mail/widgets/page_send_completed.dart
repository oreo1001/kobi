import 'package:flutter/material.dart';

class SentCompleted extends StatelessWidget {
  const SentCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body : Center(child: Column(
      children: [
        Text('메일을 성공적으로 보냈습니다.'),
        Text('메일 목록 돌아가기')//
      ],
    )));
  }
}