import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Controller/auth_controller.dart';
import 'package:kobi/Main/page_main.dart';
import 'package:get/get.dart';
import 'Login/loading_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Login/page_login.dart';
import 'function_user_login.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // 잘은 모르는데 background Isolate라 한번 더 초기화 해줘야 하는듯
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}


void main() async {
  WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
  ///Native Splash를 위한 코드 (splash를 바인딩)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // 이거 두개는 최상단에서 해야 될듯
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(AuthController(),permanent: true);
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
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(395.0, 785.0),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko'),
          Locale('en'),
        ],
        locale: const Locale('ko'),
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
            GetPage(name: '/main', page: () => const MainPage()),
            GetPage(name: '/login', page: () => const LoginPage()),
            GetPage(name: '/loading', page: () => const LoadingPage()),
            // GetPage(name: '/test', page:()=> TestPage()),
          ],
          home: FutureBuilder(      //로그인 확인하여 페이지 라우팅
            future: getUserProfile(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 로딩 중일 때 보여줄 위젯
              } else {
                FlutterNativeSplash.remove();
                final bool? isLogged = snapshot.data;
                if (isLogged == null || !isLogged) {
                  return const LoginPage();
                } else {
                  return const MainPage();
                }
              }
            }
          ),
      ),
    );
  }
}
