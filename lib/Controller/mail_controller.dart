import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Mail/class_email.dart';
import '../Mail/methods/function_thread_data.dart';

class MailController extends GetxController {
  RxInt threadIndex = 0.obs;
  RxList<Thread> filterThreadList =<Thread>[].obs;
  RxInt unreadMessageCount = 0.obs;

  // void updateUnreadMessageCount(List<Message> messageList) {
  //   unreadMessageCount.value = unreadMessageCountFunc(messageList);
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
      if (filterThreadList[i].threadId == thread.threadId) {
        markAllAsRead(filterThreadList[i].messages);
        break;
      }
    }
  }
}