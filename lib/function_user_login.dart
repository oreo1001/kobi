import 'package:get/get.dart';
import 'package:kobi/Controller/auth_controller.dart';

import 'Class/secure_storage.dart';
import 'User/class_contact.dart';
import 'function_http_request.dart';

final storage = SecureStorage();
AuthController authController = Get.find();

Future<bool> checkIfLogin() async {
  String? userId = await storage.getUserId();
  print('userId 값: $userId');
  if(userId == null || userId.isEmpty){
    return false;
  }
  return true;
}

Future<bool> getUserProfile() async {
  bool isLoggedIn = await checkIfLogin();    //로그인 확인되면 함수 실행
  if (isLoggedIn) {
    String? token = await authController.getToken();
    await authController.loadUser();

    String userId = authController.userId.value;
    Map<String, dynamic> responseMap = await httpResponse('/auth/login', {'fcmToken': token, 'user': userId});

    authController.contactList.value = convertDynamicListToContactList(responseMap['contactList']);
    print('contactList: ${authController.contactList.toString()}');
    return true;
  }
  else{
    return false;
  }
}