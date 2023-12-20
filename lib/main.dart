import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:kobi/page_main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:kobi/Controller/notification_controller.dart';
import 'Alarm/page_ringing.dart';
import 'Alarm/function_alarm_initializer.dart';
import 'Alarm/page_alarm.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  // needed if you intend to initialize in the `main` function
  //const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');  //메소드 채널 이름 설정
  Get.put(NotificationController(),permanent: true);
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
  String? selectedNotificationPayload;     //알람을 눌렀을 때
  NotificationAppLaunchDetails? notificationAppLaunchDetails;

  @override
  void initState() {
    super.initState();
    //_initNotificationDetails();
  }

  void _initNotificationDetails() async {
    notificationAppLaunchDetails = await notificationController
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();   //알람 plugin이 mac, ios, android에서 오지않으면 didNotificationLaunchApp을 false로 만듬.
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
      designSize: const Size(390.0, 800.0),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
          title: 'WonMo Calendar',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan[300]!),
            useMaterial3: true,
          ),
          getPages: [
            GetPage(name: '/', page:()=> MainPage()),
            GetPage(
                name: '/alarm',
                page: () => AlarmPage(notificationAppLaunchDetails)),
            GetPage(
                name: '/ringing',
                page: () => RingingPage(selectedNotificationPayload)),
          ],
          home: MainPage()),
    );
  }
}
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
