import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Class/class_my_event.dart';
import 'package:kobi/Dialog/delete_dialog.dart';
import 'package:mime/mime.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  Future<String> _getMimeType() async {
    return lookupMimeType('assets/images/test.html')!;
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _getMimeType(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Text('MIME Type: ${snapshot.data}');
              }
            },
          ),
        ),
      );
  }
}
