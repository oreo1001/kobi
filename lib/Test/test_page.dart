import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Class/class_my_event.dart';
import 'package:kobi/Dialog/delete_dialog.dart';
import 'package:kobi/Dialog/event_dialog.dart';
import 'package:kobi/Dialog/update_event_dialog.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../Assistant/ResponseWidgets/create_email.dart';
import '../Assistant/ResponseWidgets/delete_event.dart';
import '../Controller/auth_controller.dart';
import '../User/class_contact.dart';
import '../in_app_notification/in_app_notification.dart';
import '../theme.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final textEditingController = TextEditingController();
  List<Contact> contactList = [];
  AuthController authController = Get.find();
  String query = '';

  @override
  void initState() {
    super.initState();
    contactList = authController.contactList;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyEvent event = MyEvent(
        id: 'ddd',
        summary: '안녕하세요 반갑습니다 안녕하세요 반갑습니다안녕하세요 반갑습니다안녕하세요 반갑습니다안녕하세요 반갑습니다',
        startTime: '2024-02-23T14:00:00+09:00',
        endTime: '2024-02-24T14:00:00+09:00',
        isAllDay: false);
    final results = contactList.where((contact) =>
        contact.name.toLowerCase().contains(query.toLowerCase()) ||
        contact.emailAddress.toLowerCase().contains(query.toLowerCase()));
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            style: TextStyle(color: Colors.black, fontSize: 12.sp),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 0),
              hintText: '이메일 검색',
              hintStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
            ),
          ),
          Divider(color: Colors.grey.shade200),
          SizedBox(
            height: 500.h,
            child: ListView(
              children: results.map((Contact contact) {
                return DropdownMenuItem<Contact>(
                  value: contact,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 50.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: textTheme().bodySmall?.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            children: highlightOccurrences(contact.name, query),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: textTheme().bodySmall?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                              children: highlightOccurrences(contact.emailAddress, query),
                            ),
                          ),
                        ),
                        Icon(Icons.clear, color: Colors.grey.shade600, size: 15.sp),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty) {
      return [TextSpan(text: source)];
    }
    var spans = <TextSpan>[];
    int start = 0;
    int indexOfHighlight = source.toLowerCase().indexOf(query.toLowerCase());
    while (indexOfHighlight != -1) {
      spans.add(TextSpan(text: source.substring(start, indexOfHighlight)));
      spans.add(TextSpan(text: source.substring(indexOfHighlight, indexOfHighlight + query.length), style: TextStyle(color: Colors.blue)));
      start = indexOfHighlight + query.length;
      indexOfHighlight = source.toLowerCase().indexOf(query.toLowerCase(), start);
    }
    spans.add(TextSpan(text: source.substring(start)));
    return spans;
  }
}
