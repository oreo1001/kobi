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

void main() async {
  WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  ///Native Splash를 위한 코드 (splash를 바인딩)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Get.put(NotificationController(), permanent: true);
  alarmInitializeFunction();

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

  @override
  void initState() {
    super.initState();
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
