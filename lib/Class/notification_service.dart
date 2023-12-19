// import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../alarm/class_received_notification.dart';
//
// class NotificationService {
//   final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
//   final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   void closeStreams() {
//     didReceiveLocalNotificationStream.close();
//     selectNotificationStream.close();
//   }
// }