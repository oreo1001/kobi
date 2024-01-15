import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kobi/Mail/class_email.dart';

import '../../theme.dart';
import '../methods/function_mail_date.dart';
import '../methods/match_email_to_color.dart';

class MailRoom extends StatefulWidget {
  Thread thread;
  RxBool isLongPressed;
  RxBool isSelected;

  MailRoom(
    this.thread,
    this.isLongPressed,
    this.isSelected, {
    Key? key,
  }) : super(key: key);

  @override
  _MailRoomState createState() => _MailRoomState();
}

class _MailRoomState extends State<MailRoom> {
  Color profileColor = Colors.white;
  RxList<Message> messageList = <Message>[].obs;

  @override
  void initState() {
    super.initState();
    messageList = widget.thread.messages;
  }

  @override
  Widget build(BuildContext context) {
    profileColor = matchEmailToColor(widget.thread.emailAddress);
    messageList = widget.thread.messages;
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isLongPressed.value
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 10.h, 15.w, 10.h),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isSelected.value? Colors.white: Colors.grey, // 원하는 테두리 색상 설정
                      width: 2.sp, // 원하는 테두리 두께 설정
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28.sp,
                    backgroundColor:
                        widget.isSelected.value ? Colors.blue : Colors.white,
                    child: widget.isSelected.value ? const Icon(Icons.check,color : Colors.white) : Container(),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(0, 10.h, 15.w, 10.h),
                child: CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: profileColor, // 선택되었을 때와 아닐 때의 배경색
                  child: Text(
                    widget.thread.name.isEmpty ? '' : widget.thread.name[0],
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
        Container(
          padding: EdgeInsets.only(right: 2.w),
          width: 280.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 215.w,
                    child: Text(widget.thread.name,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme()
                            .displayLarge
                            ?.copyWith(fontSize: 17.sp)),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      mailDateString(
                        messageList.last.date,
                      ),
                      style: textTheme().bodySmall?.copyWith(
                          fontSize: 10.sp, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 225.w,
                child: Text(
                  messageList.last.subject.trim().isEmpty
                      ? '(제목 없음)'
                      : messageList.last.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme().displaySmall?.copyWith(fontSize: 13.sp),
                ),
              ),
              SizedBox(
                width: 225.w,
                child: Text(
                  messageList.last.body,
                  maxLines: 1,
                  softWrap: true,
                  style: textTheme().displaySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              // Text(widget.thread.emailAddress),
            ],
          ),
        ),
      ],
    ));
  }
}
