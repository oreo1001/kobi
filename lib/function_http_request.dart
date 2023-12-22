import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> httpResponse(String path, Map<String, dynamic> body) async {
  String uri = 'https://back.wonmo.net$path';

  // final storage = SecureStorage();
  // String user = await storage.getUserId() ?? '';
  // if (user != '') {
  //   body['user'] = user;
  // }
  body['user']= 'google-113720332858503328418';
  // body['version'] = '2.0.3';  //& versionName
  String platform = 'Android도, iOS도 아님';
  if (Platform.isAndroid) {
    platform = 'Android';
  } else if (Platform.isIOS) {
    platform = 'iOS';
  }
  body['platform'] = platform;

  print('-----------------HTTP API 리퀘스트 보내기--------------------');
  print('uri : $uri');
  print('HTTP request body : $body');
  http.Response response = await http.post(Uri.parse(uri),
      headers: <String, String>{'Content-Type': "application/json"}, body: jsonEncode(body));
  if (uri != 'https://back.wonmo.net/email/emailList' && uri != 'https://back.wonmo.net/calendar/eventList') print('-----------------HTTP API 응답--------------------');
  Map<String, dynamic> responseMap;
  if (response.statusCode == 200) {
    // 서버가 요청을 성공적으로 수행한 경우
    String responseBody = utf8.decode(response.bodyBytes);
    responseMap = json.decode(responseBody);
    responseMap['statusCode'] = response.statusCode;
  } else {
    String responseBody = utf8.decode(response.bodyBytes);
    responseMap = json.decode(responseBody);
    responseMap['statusCode'] = response.statusCode;
  }

  if (uri != 'https://back.wonmo.net/email/emailList' && uri != 'https://back.wonmo.net/calendar/eventList') print('responseMap: $responseMap');
  return responseMap;
}