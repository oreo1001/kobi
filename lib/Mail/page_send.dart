import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Dialog/invalid_email_dialog.dart';
import 'package:kobi/Mail/widgets/page_send_completed.dart';

import '../User/class_contact.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'class_email.dart';

class SendPage extends StatefulWidget {
  SendPage({this.testMail, Key? key}) : super(key: key);
  TestMail? testMail;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  MailController mailController = Get.find();
  AuthController authController = Get.find();
  List<Contact> contactList = [];
  Contact? selectedContact;
  String sendMailAddress = '';
  bool _showDropdown = false;

  String query = '';

  @override
  void initState() {
    super.initState();
    contactList = authController.contactList;
    sendMailAddress = mailController
        .threadList[mailController.threadIndex.value].emailAddress;
    if (widget.testMail != null) {
      titleController.text = widget.testMail!.title;
      bodyController.text = widget.testMail!.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    var results = contactList.where((contact) =>
        contact.name.toLowerCase().contains(query.toLowerCase()) ||
        contact.emailAddress.toLowerCase().contains(query.toLowerCase()));
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 40.h, 0, 10.h),
            child: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios, size: 25.sp)),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () async {
                        if (sendMailAddress == '') {
                          showInvalidEmailDialog();
                        } else {
                          String messageId = generateRandomId(20);
                          String nowDate =
                              DateFormat("EEE, dd MMM yyyy HH:mm:ss Z")
                                  .format(DateTime.now());
                          Message sendMessage = Message(
                              sentByUser: true,
                              date: nowDate,
                              subject: titleController.text,
                              body: bodyController.text,
                              messageId: messageId,
                              unread: false,
                              snippet: '');
                          mailController.insertMessage(sendMessage);
                          await httpResponse('/email/send', {
                            "messageId": messageId,
                            "reply": true,
                            "title": titleController.text,
                            "body": bodyController.text,
                            "emailAddress": sendMailAddress
                          });
                          setState(() {});
                          Get.to(() => const SentCompleted());
                        }
                      },
                      icon: Icon(Icons.send, size: 25.sp)),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text('받는사람',
                          style: textTheme().bodySmall?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ))),
                  SizedBox(width: 5.w),
                  if (_showDropdown)
                    Container(
                      width: 230.w,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 0),
                          hintText: '이메일 검색',
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  if (!_showDropdown)
                    Container(
                        height: 30.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffD8EAF9),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.all(Radius.circular(13.sp)),
                        ),
                        child: Row(
                          children: [
                            Text(sendMailAddress,
                                style: textTheme().bodySmall?.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),
                            SizedBox(
                              height: 20.h,
                              width: 23.w,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      sendMailAddress = ''; //초기화
                                      _showDropdown = true;
                                      query = ''; //초기화
                                    });
                                  },
                                  icon: Icon(Icons.close, size: 20.sp)),
                            ),
                          ],
                        )),
                  _showDropdown
                      ? IconButton(
                      onPressed: () {
                        setState(() {
                          _showDropdown = false;
                          query = ''; //초기화
                        });
                      },
                      icon: Icon(Icons.expand_less))
                      : IconButton(
                      onPressed: () {
                        setState(() {
                          _showDropdown = true;
                        });
                      }, icon: Icon(Icons.expand_more)),
                ],
              ),
              _showDropdown ? contactWidget(results) : mailWidget()
            ],
          ),
        ));
  }

  Column contactWidget(Iterable<Contact> results) {
    return Column(
      children: [
        Divider(color: Colors.grey.shade200),
        SizedBox(
          height: 500.h,
          child: ListView(
            children: results.map((Contact contact) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    sendMailAddress = contact.emailAddress;
                    _showDropdown = false;
                    query = ''; //초기화
                  });
                },
                child: DropdownMenuItem<Contact>(
                  value: contact,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 50.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          contact.name.trim()==contact.emailAddress.trim()? Container(): RichText(
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
                              children: highlightOccurrences(
                                  contact.emailAddress, query),
                            ),
                          ),
                        ),
                        Icon(Icons.clear,
                            color: Colors.grey.shade600, size: 15.sp),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Column mailWidget() {
    return Column(
      children: [
        Divider(color: Colors.grey.shade300),
        TextFormField(
          cursorColor: const Color(0xff759CCC),
          controller: titleController,
          style: textTheme().bodySmall?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(15.w, 7.h, 15.w, 7.h),
              hintStyle: textTheme().bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
              hintText: "제목"),
          onTap: () {},
        ),
        Divider(color: Colors.grey.shade300),
        SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              color: Colors.transparent,
              height: 450.h -
                  MediaQuery.of(context).viewInsets.bottom, //키보드 자판 위젯 고려
              child: TextFormField(
                cursorColor: const Color(0xff759CCC),
                controller: bodyController,
                maxLines: null,
                style: textTheme().bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                    hintStyle: textTheme().bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                    hintText: "내용 작성"),
              ),
            ),
          ),
        )
      ],
    );
  }

  String generateRandomId(int length) {
    final Random _random = Random();
    const _chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    return List.generate(
        length, (index) => _chars[_random.nextInt(_chars.length)]).join();
  }
}

List<TextSpan> highlightOccurrences(String source, String query) {
  if (query == null || query.isEmpty) {
    return [TextSpan(text: limitText(source, 30))];
  }
  var spans = <TextSpan>[];
  int start = 0;
  int indexOfHighlight = source.toLowerCase().indexOf(query.toLowerCase());
  while (indexOfHighlight != -1) {
    spans.add(TextSpan(text: source.substring(start, indexOfHighlight)));
    spans.add(TextSpan(
        text:
        limitText(source.substring(indexOfHighlight, indexOfHighlight + query.length),25),
        style: TextStyle(color: Colors.blue)));
    start = indexOfHighlight + query.length;
    indexOfHighlight = source.toLowerCase().indexOf(query.toLowerCase(), start);
  }
  spans.add(TextSpan(text: limitText(source.substring(start),30)));
  return spans;
}

String limitText(String text, int limit) {
  return (text.length <= limit)
      ? text
      : '${text.substring(0, limit)}...';
}