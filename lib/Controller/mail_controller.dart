import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Mail/class_email.dart';
import '../Mail/methods/function_thread_data.dart';

class MailController extends GetxController {
  RxInt threadIndex = 0.obs;
  RxList<Thread> filterThreadList =<Thread>[].obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getAppointments(); // 페이지 로드될 때 데이터 로드
  // }
  void insertMessage(Message message) {
    int index = filterThreadList.indexWhere((thread) => thread.threadId == filterThreadList[threadIndex.value].threadId);
    if (index != -1) {
      filterThreadList[index].messages.add(message);
    } else {
      print('Thread not found');
    }
  }
  void readMessage(Thread thread){
    for (var i = 0; i < filterThreadList.length; i++) {
      if (filterThreadList[i] == thread) {
        markAllAsRead(filterThreadList[i].messages);
        break;
      }
    }
  }
  int unreadMessageCount(List<Message> messageList) {
    int count = 0;
    for (var message in messageList) {
      if (message.unread) {
        count++;
      }
    }
    return count;
  }
}