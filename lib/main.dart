import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Main/page_main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:kobi/Controller/notification_controller.dart';
import 'Alarm/page_ringing.dart';
import 'Alarm/function_alarm_initializer.dart';
import 'Alarm/page_alarm.dart';

import 'Controller/event_controller.dart';
import 'Dialog/delete_dialog.dart';
import 'Dialog/event_dialog.dart';
import 'Dialog/update_event_dialog.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Class/secure_storage.dart';
import 'Login/page_login.dart';
import 'User/class_contact.dart';
import 'function_http_request.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
//firebase_messaging에서 나온 방식 프래그마틱 방식으로 다트 컴파일러에게 진입점 임을 알려주어 우선적으로 실행되게 한다. */
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);   //백그라운드에서 초기화
  print('메시지 아이디 : ${message.messageId}');
  print('백그라운드 : ${message.data}');
}

void main() async {
  WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  ///Native Splash를 위한 코드 (splash를 바인딩)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Get.put(NotificationController(), permanent: true);
  alarmInitializeFunction();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(     /// 첫 빌드시, 권한 확인하기
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  Get.put(EventController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  NotificationController notificationController = Get.find();
  String? selectedNotificationPayload; //알람을 눌렀을 때
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  AuthController authController = Get.put(AuthController(),permanent: true);
  final storage = SecureStorage();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final AndroidNotificationChannel firebaseChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    // importance: Importance.max,
  );

  /// 2. 그 채널을 우리 메인 채널로 정해줄 플러그인을 만들어준다.
  final FlutterLocalNotificationsPlugin fireBasePlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    getUserProfile();
    _onMessage();
    showFirebaseDialog();
    //_initNotificationDetails();
  }

  Future<bool> checkIfLogin() async {
    String? userId = await storage.getUserId();
    print('userId 값: $userId');
    if(userId == null || userId.isEmpty){
      return false;
    }
    return true;
  }

  Future<bool> getUserProfile() async {
    bool isLoggedIn = await checkIfLogin();
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

  void _initNotificationDetails() async {
    notificationAppLaunchDetails = await notificationController
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails(); //알람 plugin이 mac, ios, android에서 오지않으면 didNotificationLaunchApp을 false로 만듬.
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      Get.off(() => RingingPage(selectedNotificationPayload));
    } else {
      Get.off(() => AlarmPage(notificationAppLaunchDetails));
    }
  }
  void showFirebaseDialog(){
    final EventController eventController = Get.find<EventController>();
    print("type: ${eventController.type.value}");
    if(eventController.type.value == 'insert_event'){
      showEventDialog();
    }else if(eventController.type.value == 'update_event'){
      showUpdateEventDialog();
    }else if(eventController.type.value == 'delete_event'){
      showDeleteDialog();
    }
  }

  void _onMessage() async {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setEvent(message.data);
      });
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('기기의 가로 길이 : ${MediaQuery.of(context).size.width}');
    print('기기의 세로 길이 : ${MediaQuery.of(context).size.height}');
    return ScreenUtilInit(
      designSize: const Size(395.0, 785.0),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
          title: 'WonMo Calendar',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all(true),
                thickness: MaterialStateProperty.all(10),
                thumbColor: MaterialStateProperty.all(Colors.amber),
                radius: const Radius.circular(10),
              )),
          getPages: [
            GetPage(name: '/', page: () => MainPage()),
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(
                name: '/alarm',
                page: () => AlarmPage(notificationAppLaunchDetails)),
            GetPage(
                name: '/ringing',
                page: () => RingingPage(selectedNotificationPayload)),
          ],
          home: FutureBuilder<bool>(      //로그인 확인하여 페이지 라우팅
            future: getUserProfile(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 로딩 중일 때 보여줄 위젯
              } else {
                FlutterNativeSplash.remove();
                final bool? isLogged = snapshot.data;
                if (isLogged == null || !isLogged) {
                  return LoginPage();
                } else {
                  return MainPage();
                }
              }
            }
          ),
      ),
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
