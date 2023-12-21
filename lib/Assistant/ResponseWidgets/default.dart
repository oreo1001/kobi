import 'package:flutter/material.dart';

class DefaultResponse extends StatelessWidget {
  const DefaultResponse({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('당신 곁에 언제나 커리비'),
          Text("'커리비'를 불러서 이렇게 말해보세요"),
          Text("바보"),
          Text("멍청이"),
        ],
      ),
    );
  }
}
