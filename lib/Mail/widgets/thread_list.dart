import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kobi/Mail/widgets/unread_mark.dart';

import '../../function_http_request.dart';
import '../class_email.dart';
import '../methods/function_parsing.dart';
import '../methods/match_email_to_color.dart';
import '../page_thread.dart';
import 'mail_room.dart';

class ThreadList extends StatefulWidget {
  ThreadList({super.key, required this.threadList});

  List<Thread> threadList;

  @override
  State<ThreadList> createState() => _ThreadListState();
}

class _ThreadListState extends State<ThreadList> {

  static const _pageSize = 10;
  final PagingController<int, Thread> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      addThreads(pageKey);
    });
    super.initState();
  }

  void addThreads(int pageKey) {
    // 시작 인덱스 계산
    int startIndex = _pageSize * pageKey;

    // 시작 인덱스가 리스트의 길이를 초과하는 경우, 빈 리스트 반환
    if (startIndex >= widget.threadList.length) {
      return;
    }

    // 끝 인덱스 계산: 리스트의 끝을 초과하지 않도록 조정
    int endIndex = startIndex + _pageSize;
    endIndex = endIndex > widget.threadList.length ? widget.threadList.length : endIndex;

    // 페이지에 해당하는 서브리스트 반환
    return _pagingController.appendPage(widget.threadList.sublist(startIndex, endIndex), endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Thread>(
            itemBuilder: (BuildContext context, Thread thread, int index) {
              final messageList = parsingMessageListFromThread(thread.messages);
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(() => ThreadPage(thread));
                  httpResponse('/email/read', {"messageIdList": unreadMessageIdList(messageList)});
                },
                child:
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                  child: Stack(
                      children: [
                        mailRoom(matchEmailToColor(thread.emailAddress), thread, messageList),
                        /// 안 읽은 메일 개수
                        unreadMark(messageList)]
                  ),
                ),
              );
            }

        )
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
