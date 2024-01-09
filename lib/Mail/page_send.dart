import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Dialog/invalid_email_dialog.dart';
import 'package:kobi/Mail/widgets/page_send_completed.dart';

import '../User/class_contact.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'class_email.dart';

class SendPage extends StatefulWidget {
  SendPage({super.key});

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

  @override
  void initState() {
    super.initState();
    contactList = authController.contactList;
    sendMailAddress = mailController.threadList[mailController.threadIndex.value].emailAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 50.h, 0, 10.h),
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
                          Message sendMessage = Message(sentByUser: true, date: DateTime.now().toString(), subject: titleController.text, body: bodyController.text, messageId: messageId, unread: false);
                          mailController.insertMessage(sendMessage);
                          await httpResponse('/email/send', {
                            "messageId": 'messageId',
                            "reply": true,
                            "title": titleController.text,
                            "body": bodyController.text,
                            "emailAddress": sendMailAddress
                          });
                          Get.back();
                          // Get.to(()=> SentCompleted(currentThread: widget.currentThread));
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
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ))),
                  SizedBox(width: 5.w),
                  if (_showDropdown)
                    DropdownButtonHideUnderline(
                      child: DropdownButton<Contact>(
                        hint: Padding(
                          padding: EdgeInsets.fromLTRB(10.w,0,0,0),
                          child: Text('나의 연락처 목록 열기',  // 추가된 부분
                              style: textTheme().bodySmall?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade400,
                              )),
                        ),
                        dropdownColor: Colors.white,
                        elevation: 1,
                        iconSize: 0,
                        isDense: true,
                        items: contactList.map((Contact contact) {
                          return DropdownMenuItem<Contact>(
                            value: contact,
                            child: SizedBox(
                              height: 50.h,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width:250.w,
                                    child: Text(contact.name,
                                        style: textTheme().bodySmall?.copyWith(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    width:250.w,
                                    child: Text(contact.emailAddress,
                                        style: textTheme().bodySmall?.copyWith(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Divider(color: Colors.grey.shade200)
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Contact? newContact) {
                          setState(() {
                            sendMailAddress = newContact!.emailAddress;
                            _showDropdown = false;
                          });
                        },
                      ),
                    ),
                  if (!_showDropdown)
                    Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
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
                                      fontSize: 13.sp,
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
                                    });
                                  },
                                  icon: Icon(Icons.close, size: 20.sp)),
                            ),
                          ],
                        )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(color: Colors.grey.shade300),
              TextFormField(
                cursorColor: const Color(0xff759CCC),
                controller: titleController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(15.w, 7.h, 15.w, 7.h),
                    hintStyle: textTheme().bodySmall?.copyWith(
                          fontSize: 15.sp,
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                          hintStyle: textTheme().bodySmall?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                              ),
                          hintText: "내용 작성"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String generateRandomId(int length) {
    final Random _random = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    return List.generate(length, (index) => _chars[_random.nextInt(_chars.length)]).join();
  }
}
