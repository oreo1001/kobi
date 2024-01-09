import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Mail/class_email.dart';
import '../Mail/methods/function_parsing.dart';
import '../function_http_request.dart';

class MailController extends GetxController {
  RxList<Thread> threadList = <Thread>[].obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getAppointments(); // 페이지 로드될 때 데이터 로드
  // }
  Future getThread() async {
    Map<String, dynamic> responseMap = await httpResponse('/email/emailList', {});
    threadList.value = loadThreadListFromJson(responseMap['emailList']);
  }
}