import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'Class/secure_storage.dart';
import 'Controller/event_controller.dart';
import 'Dialog/delete_dialog.dart';
import 'Dialog/event_dialog.dart';
import 'Dialog/update_event_dialog.dart';

final storage = SecureStorage();
FirebaseMessaging messaging = FirebaseMessaging.instance;
const AndroidNotificationChannel firebaseChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  // importance: Importance.max,
);

/// 2. 그 채널을 우리 메인 채널로 정해줄 플러그인을 만들어준다.
final FlutterLocalNotificationsPlugin fireBasePlugin = FlutterLocalNotificationsPlugin();

void firebaseOnMessage() async {
  /// * local_notification 관련한 플러그인 활용 *
  /// 1. 위에서 생성한 channel 을 플러그인 통해 메인 채널로 설정한다.
  await fireBasePlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(firebaseChannel);

  /// 2. 플러그인을 초기화하여 추가 설정을 해준다.
  await fireBasePlugin.initialize(
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

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {       //android일떄만 flutterLocalNotification
      fireBasePlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(firebaseChannel.id, firebaseChannel.name, channelDescription: firebaseChannel.description),
          ),
          // 넘겨줄 데이터가 있으면 아래 코드를 써주면 됨.
          payload: message.data['argument']);
    }
    print('메시지 아이디 : ${message.messageId}');
    print('포그라운드 : ${message.data}');
    setEvent(message.data);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {  ///background -> foreground tap
    print('백그라운드에서 탭했을때 포그라운드로 전환');
    _handleMessage(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {  ///terminated
    if (message != null) {
      print('terminated 상태에서 메시지 확인: ${message.data}');
      _handleMessage(message);
    }
  });
}

void setEvent(Map<String,dynamic> eventMap){
  final EventController eventController = Get.find();
  if (eventMap['type'] == 'insert_event') {
    eventController.setCurrentEvent(eventMap);
    showEventDialog();
  } else if (eventMap['type'] == 'update_event') {
    eventController.setBeforeEvent(json.decode(eventMap['before_event']));
    eventController.setCurrentEvent(json.decode(eventMap['after_event']));
    showUpdateEventDialog();
  }else if (eventMap['type'] == 'delete_event'){
    eventController.setDeleteEvent(eventMap);
    showDeleteDialog();
  }
}
void _handleMessage(RemoteMessage message) async {
  String? userId = await storage.getUserId();
  if (userId != '' && userId != null) {
    Get.offAllNamed('/main');
    setEvent(message.data);
  } else {
    Get.offAllNamed('/login');
  }
}