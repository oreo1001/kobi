import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../Class/secure_storage.dart';
import '../User/class_contact.dart';

class AuthController extends GetxController {
  RxString userId = ''.obs;
  RxString name = ''.obs;
  RxString photoUrl = ''.obs;
  RxString email = ''.obs;

  RxList<Contact> contactList = <Contact>[].obs;
  String? token;

  Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    try {
      print('디바이스의 fcmToken : $token');
      return token;
    } catch (e) {
      return null;
    }
  }

  ///사용자 불러오기
  Future<void> loadUser() async {
    final storage = SecureStorage();
    Map<String, String> storedUser = await storage.getUser(['displayName', 'email', 'userId', 'photoUrl']);

    print('storedUser: $storedUser');
    if (storedUser['userId'] != null && storedUser['userId']!.isNotEmpty) {
      userId.value = storedUser['userId']!;
    }
    if (storedUser['displayName'] != null && storedUser['displayName']!.isNotEmpty) {
      name.value = storedUser['displayName']!;
    }
    if (storedUser['email'] != null && storedUser['email']!.isNotEmpty) {
      email.value = storedUser['email']!;
    }
    if (storedUser['photoUrl'] != null && storedUser['photoUrl']!.isNotEmpty) {
      photoUrl.value = storedUser['photoUrl']!;
    }
  }
}