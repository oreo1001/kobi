import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kobi/Controller/auth_controller.dart';

Future<Map<String, dynamic>> httpResponse(String path, Map<String, dynamic> body) async {
  String uri = 'http://13.209.152.32$path';

  AuthController authController = Get.find();
  String user = authController.userId.value;

  if (user != '') {
    body['user'] = user;
  }

  body['version'] = '2.0.3';

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
  print('HTTP request time : ${DateTime.now().toString().substring(0, 19)}');
  http.Response response = await http.post(Uri.parse(uri),
      headers: <String, String>{'Content-Type': "application/json"}, body: jsonEncode(body));
  if (uri != 'http://13.209.152.32/email/emailList' && uri != 'http://13.209.152.32/calendar/eventList')
    print('-----------------HTTP API 응답--------------------');
  print('HTTP response time : ${DateTime.now().toString().substring(0, 19)}');

  Map<String, dynamic> responseMap;

  String responseBody = utf8.decode(response.bodyBytes);
  responseMap = json.decode(responseBody);
  responseMap['statusCode'] = response.statusCode;

  if (uri != 'http://13.209.152.32/email/emailList' && uri != 'http://13.209.152.32/calendar/eventList') print('responseMap: $responseMap');
  return responseMap;
}