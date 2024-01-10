import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Controller/auth_controller.dart';
import '../Dialog/scope_dialog.dart';
import '../User/class_contact.dart';
import '../function_http_request.dart';
import '../Class/secure_storage.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GoogleSignIn googleSignIn;
  final storage = SecureStorage();
  AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  static const List<String> scopes = <String>[
    'https://www.googleapis.com/auth/calendar',
    'https://mail.google.com/',
    // 'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  Future<void> _handleSignIn() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        /// 맥 ios
        googleSignIn = GoogleSignIn(
            clientId: '372113464838-aq8pu1adst4d93qcnftapf3se8iqs7jg.apps.googleusercontent.com',
            serverClientId:
                "372113464838-u26uo4p42fv3fvnknkk6on2ougfd0edq.apps.googleusercontent.com",
            scopes: scopes,
            forceCodeForRefreshToken: true);
      } else {
        /// 안드로이드
        googleSignIn = GoogleSignIn(
            serverClientId:
            "372113464838-u26uo4p42fv3fvnknkk6on2ougfd0edq.apps.googleusercontent.com",
            scopes: scopes,
            forceCodeForRefreshToken: true);
      }
      GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      String? serverAuthCode = googleAccount?.serverAuthCode;
      String googleId = 'google-${googleAccount!.id}';
      Map<String, String> accountMap = {
        'userId': googleId,
        'displayName': googleAccount.displayName ?? '',
        'email': googleAccount.email,
        'photoUrl': googleAccount.photoUrl ?? '',
      };

      authController.userId.value = googleId;
      authController.name.value = googleAccount.displayName ?? '';
      authController.email.value = googleAccount.email;
      authController.photoUrl.value = googleAccount.photoUrl ?? '';

      String? token = await authController.getToken();

      // Get.offNamed('/loading');
      Get.offNamed('/loading');
      Map<String, dynamic> responseMap = await httpResponse('/auth/signIn',
          {'fcmToken': token, 'authCode': serverAuthCode, 'user': googleId});

      if (responseMap['statusCode'] == 400) {
        if (responseMap.containsKey('message') &&
            responseMap['message'].contains('scope')) {
          Get.back();
          showScopeDialog();
        } else {
          Get.back();
        }
      } else if (responseMap['statusCode'] == 200) {
        storage.setUser(accountMap); //로그인 되었을 때
        if (responseMap.containsKey('contactList')) {
          authController.contactList.value =
              convertDynamicListToContactList(responseMap['contactList']);
        }
        print('로그인 성공!');
        Get.offNamed('/main');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('커리비',style : textTheme().headlineMedium?.copyWith(fontSize: 50.sp, color: Color(0xff759CCC))),
            SizedBox(height: 30.h),
            SizedBox(
              width: 270.w,
              child: Image(
                image: AssetImage('assets/images/앱소개.jpg'),
              ),
            ),
            SizedBox(height: 60.h),
            Text(
              '메일 · 캘린더 자동관리',
              style: textTheme().displayLarge?.copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              '커리비는 메일을 분석해서 자동으로 관리해요.',
              style: textTheme().displayMedium?.copyWith(fontSize: 15.sp),
            ),
            Text(
              '지메일을 연동해보세요!',
              style: textTheme().displayMedium?.copyWith(fontSize: 15.sp),
            ),
            SizedBox(
              height: 30.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffACCCFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp), // 원하는 둥근 정도를 숫자로 입력하세요.
                ),
                minimumSize:  Size(350.w,50.h),
              ),
              onPressed: () async {
                _handleSignIn();
              },
              child: Container(
                width: 280.w,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 25.w,
                    child: Center(
                      child: ClipRRect(
                        child: Image.asset(
                          "assets/images/구글로고.png",
                          height: 25.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    "Gmail 연동하여 시작하기",
                    style: textTheme()
                        .displayLarge!
                        .copyWith(fontSize: 18.sp, color: Colors.white,fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
