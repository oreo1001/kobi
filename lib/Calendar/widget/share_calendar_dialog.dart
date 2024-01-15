import 'package:flutter/material.dart';

class ShareCalendarDialog extends StatefulWidget {
  @override
  _ShareCalendarDialogState createState() => _ShareCalendarDialogState();
}

class _ShareCalendarDialogState extends State<ShareCalendarDialog> {
  final TextEditingController emailController = TextEditingController();
  String selectedPermission = '한가함/바쁨 정보만 보기';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('특정 사용자와 공유'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: '이메일 주소',
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedPermission,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPermission = newValue!;
                });
              },
              items: <String>['한가함/바쁨 정보만 보기', '모든 일정 세부정보 보기', '일정 변경', '변경 및 공유 관리']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('보내기'),
          onPressed: () {
            // 보내기 버튼 로직
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}