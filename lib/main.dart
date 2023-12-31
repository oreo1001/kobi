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
import 'Controller/event_controller.dart';
import 'Login/loading_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Login/page_login.dart';
import 'function_firebase_message.dart';
import 'function_user_login.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}
//firebase_messaging에서 나온 방식 프래그마틱 방식으로 다트 컴파일러에게 진입점 임을 알려주어 우선적으로 실행되게 한다. */
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);   //백그라운드에서 초기화
  print('메시지 아이디 : ${message.messageId}');
  print('백그라운드 : ${message.data}');
  // FirebaseMessaging.instance.getInitialMessage().then((message) {  ///terminated
  //   if (message != null) {
  //     print('terminated 상태에서 메시지 확인: ${message.data}');
  //     handleMessage(message);
  //   }
  // });
}

void main() async {
  WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  ///Native Splash를 위한 코드 (splash를 바인딩)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
  Get.put(AuthController(),permanent: true);
  Get.put(EventController(),permanent: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  @override
  void initState() {
    super.initState();
    firebaseOnMessage();
    backgroundTerminate();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(395.0, 785.0),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
          title: 'WonMo Calendar',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            hoverColor: const Color(0xFFACCCFF),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all(true),
                thickness: MaterialStateProperty.all(10),
                thumbColor: MaterialStateProperty.all(Colors.amber),
                radius: const Radius.circular(10),
              )),
          getPages: [
            GetPage(name: '/main', page: () => MainPage()),
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/loading', page: () => LoadingPage()),
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
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
