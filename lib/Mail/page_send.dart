import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Controller/mail_controller.dart';
import 'package:kobi/Dialog/invalid_email_dialog.dart';
import 'package:kobi/Mail/SendWidgets/address_container.dart';
import 'package:kobi/Mail/SendWidgets/body_field.dart';
import 'package:kobi/Mail/SendWidgets/send_app_bar.dart';
import 'package:kobi/Mail/widgets/page_send_completed.dart';

import '../User/class_contact.dart';
import '../function_http_request.dart';
import '../theme.dart';
import 'SendWidgets/title_field.dart';
import 'class_email.dart';
import 'methods/function_mail_sender.dart';

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
        appBar: SendAppBar(() async {
          if (sendMailAddress == '') {
            showInvalidEmailDialog();
          } else {
            String messageId = generateRandomId(20);
            String nowDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z")
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
              "reply": true,
              "title": titleController.text,
              "body": bodyController.text,
              "emailAddress": sendMailAddress
            });
            setState(() {});
            Get.to(() => const SentCompleted());
          }
        }),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Container(
                      padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                      child: Text('받는사람',
                          style: textTheme().bodySmall?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ))),
                  SizedBox(width: 5.w),
                  if (_showDropdown)
                    SizedBox(
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
                    addressContainer(sendMailAddress, () {
                      setState(() {
                        sendMailAddress = ''; //초기화
                        _showDropdown = true;
                        query = ''; //초기화
                      });
                    }),
                  _showDropdown
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _showDropdown = false;
                              query = '';
                            });
                          },
                          icon: Icon(Icons.expand_less))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _showDropdown = true;
                            });
                          },
                          icon: Icon(Icons.expand_more)),
                ],
              ),
              _showDropdown ? contactWidget(results) : mailWidget()
            ],
          ),
        ));
  }

  SingleChildScrollView contactWidget(Iterable<Contact> results) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Divider(color: Colors.grey.shade200),
          SizedBox(
            height: 500.h,
            child: ListView(
              children: results.map((Contact contact) {
                return GestureDetector(
                  onTap: () {
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
                          contact.name.trim() == contact.emailAddress.trim()
                              ? Container()
                              : RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: textTheme().bodySmall?.copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                    children: highlightOccurrences(
                                        contact.name, query),
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
      ),
    );
  }

  Column mailWidget() {
    return Column(
      children: [
        Divider(color: Colors.grey.shade300),
        titleField(titleController),
        Divider(color: Colors.grey.shade300),
        bodyField(context, bodyController),
      ],
    );
  }
}