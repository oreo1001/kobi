import 'package:flutter/material.dart';
import 'package:kobi/Class/class_my_event.dart';
import 'package:kobi/Dialog/delete_dialog.dart';


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
            child: TextButton(
              onPressed: () {
                MyEvent event = MyEvent(summary: 'ss',
                    startTime: DateTime.now().toString(),
                    endTime: DateTime.now().add(Duration(days: 2)).toString());
                showDeleteDialog(event);
              },
              child: Text('test'),
            )),
      ),
    );
  }
}