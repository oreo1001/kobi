import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Controller/auth_controller.dart';

import '../User/class_contact.dart';
import '../theme.dart';

class SendPage extends StatefulWidget {
  SendPage(this.currentMail, {super.key});

  String currentMail;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();
  AuthController authController = Get.find();
  List<Contact> contactList = [];
  Contact? selectedContact;
  String sendMailAddress = '';
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    contactList = authController.contactList;
    sendMailAddress = widget.currentMail;
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
                      onPressed: () {
                        Get.back();
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
                  Visibility(
                    visible: _showDropdown ? true : false,
                    maintainSize: false,
                    child: Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Contact>(
                          iconSize: 0,
                          isDense: true,
                          items: contactList.map((Contact contact) {
                            return DropdownMenuItem<Contact>(
                              value: contact,
                              child:
                                  Text('${contact.name} ${contact.emailAddress}'),
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
                    ),
                  ),
                  Visibility(
                    visible: _showDropdown ? false : true,
                    maintainSize: false,
                    child: Container(
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
                                      _showDropdown = true;
                                    });
                                  },
                                  icon: Icon(Icons.close, size: 20.sp)),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(color: Colors.grey.shade300),
              TextFormField(
                cursorColor: const Color(0xff759CCC),
                controller: subjectController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    EdgeInsets.fromLTRB(15.w, 7.h, 15.w, 7.h),
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
                    color:Colors.transparent,
                    height: 450.h - MediaQuery.of(context).viewInsets.bottom,  //키보드 자판 위젯 고려
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
                          contentPadding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
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
}
