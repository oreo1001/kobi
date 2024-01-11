import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Mail/class_email.dart';
import '../Mail/methods/function_thread_data.dart';

class MailController extends GetxController {
  RxInt threadIndex = 0.obs;
  RxList<Thread> threadList =<Thread>[].obs;
  RxList<int> unreadCounterList = <int>[].obs;

  void insertMessage(Message message) {
    int index = threadList.indexWhere((thread) => thread.threadId == threadList[threadIndex.value].threadId);
    if (index != -1) {
      threadList[index].messages.add(message);
    } else {
      print('Thread not found');
    }
    threadList[index].messages.refresh();
  }
  void findThreadIndex(Thread targetThread){
    threadIndex = threadList.indexWhere((thread) => thread.threadId == targetThread.threadId).obs;
  }
  void readMessage(Thread thread){
    for (var i = 0; i < threadList.length; i++) {
      if (threadList[i].threadId == thread.threadId) {
        threadList[i].messages = markAllAsRead(threadList[i].messages);
        break;
      }
    }
  }
}