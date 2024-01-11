import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kobi/Mail/class_email.dart';

import '../../theme.dart';
import '../methods/function_mail_date.dart';
import '../methods/match_email_to_color.dart';

class MailRoom extends StatefulWidget {
  final Thread thread;

  const MailRoom({
    Key? key,
    required this.thread,
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
    profileColor = matchEmailToColor(widget.thread.emailAddress);
    messageList = widget.thread.messages;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10.h, 15.w, 10.h),
          child: CircleAvatar(
            radius: 30.sp,
            backgroundColor: profileColor,
            child: Text(
              widget.thread.name.isEmpty ? '' : widget.thread.name[0],
              // 첫 번째 글자만 가져옴
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
    );
  }
}
