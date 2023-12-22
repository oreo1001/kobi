import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  Future setUser(Map<String, String> googleAccountInfo) async {
    for (var key in googleAccountInfo.keys) {
      await storage.write(key: key, value: googleAccountInfo[key].toString());
    }
  }

  // 저장된 사용자 ID 가져오기
  Future<String?> getUserId() async {
    String? userId = await storage.read(key: 'userId');
    return userId;
  }

  Future<Map<String, String>> getUser(List<String> keys) async {
    Map<String, String> userInfo = {};
    for (var key in keys) {
      String? value = await storage.read(key: key);
      userInfo[key] = value ?? '';
    }
    return userInfo;
  }
}