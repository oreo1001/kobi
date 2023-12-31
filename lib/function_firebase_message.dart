import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kobi/firebase_options.dart';
import 'Class/class_my_event.dart';
import 'Class/secure_storage.dart';
import 'Dialog/delete_dialog.dart';
import 'Dialog/event_dialog.dart';
import 'Dialog/update_event_dialog.dart';

Future<void> setupInteractedMessage(void Function(RemoteMessage) handleMessage) async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

Future<void> initializeIosForegroundMessaging(void Function(RemoteMessage) handleMessage) async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    handleMessage(message);
  });
}

Future<void> initializeAndroidForegroundMessaging(void Function(RemoteMessage) handleMessage) async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  // Android용 새 Notification Channel
  const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
    'high_importance_channel', // 임의의 id
    'High Importance Notifications', // 설정에 보일 채널명
    description: 'This channel is used for important notifications.', // 설정에 보일 채널 설명
    importance: Importance.max,
  );

  // Notification Channel을 디바이스에 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  /// 2. 플러그인을 초기화하여 추가 설정을 해준다.
  await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('notification_icon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      // onDidReceiveBackgroundNotificationResponse: backgroundHandler,
      onDidReceiveNotificationResponse: (details) {
        print('알림 : $details');
      });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    handleMessage(message);

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidNotificationChannel.id,
              androidNotificationChannel.name,
              channelDescription: androidNotificationChannel.description,
              // other properties...
            ),
          ));
    }
  });
}