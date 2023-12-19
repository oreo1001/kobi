import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../alarm/class_received_notification.dart';

class NotificationController extends GetxController {
  final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
  final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // StreamController 객체 생성
  // final StreamController<ReceivedNotification> = StreamController<ReceivedNotification>.broadcast().obs
  // final StreamController<String?> = StreamController<String?>.broadcast().obs;

  @override
  void onClose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.onClose();
  }
}