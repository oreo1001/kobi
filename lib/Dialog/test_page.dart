import 'package:flutter/material.dart';
import 'package:kobi/Dialog/page_auto_dialog.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String sendMailAddress = 'careebee@wonmo.net';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          child: Text('Show Schedule'),
          onPressed: () {
            showAutoDialog();
              },
            ),
        ),
      );
  }
}
