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
            serverClientId:
            "372113464838-u26uo4p42fv3fvnknkk6on2ougfd0edq.apps.googleusercontent.com",
            scopes: scopes,
            forceCodeForRefreshToken: true);
      } else {
        /// 안드로이드
        googleSignIn = GoogleSignIn(
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

      Get.toNamed('/loading');

      authController.userId.value = googleId;
      authController.name.value = googleAccount.displayName ?? '';
      authController.email.value = googleAccount.email;
      authController.photoUrl.value = googleAccount.photoUrl ?? '';

      String? token = await authController.getToken();

      Map<String, dynamic> responseMap = await httpResponse('/auth/signIn',
          {'fcmToken': token, 'authCode': serverAuthCode, 'user': googleId});

      if (responseMap['statusCode'] == 400) {
        if (responseMap.containsKey('message') &&
            responseMap['message'].contains('scope')) {
          Get.offNamed('/login');
          showScopeDialog();
          print('scope 오류');
        } else {
          print('400 다른 오류');
          Get.offNamed('/login');
        }
      } else if (responseMap['statusCode'] == 200) {
        storage.setUser(accountMap); //로그인 되었을 때
        if (responseMap.containsKey('contactList')) {
          authController.contactList.value =
              convertDynamicListToContactList(responseMap['contactList']);
        }
        Get.offNamed('/');
      } else {
        print('error가 생성되었어요! 500 이거나 다른 오류');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Kobi가 여러분의 일정 관리를 책임질게요!',
            style: textTheme().displayLarge?.copyWith(fontSize: 20.sp),
          ),
          SizedBox(
            height: 50.h,
          ),
          Text(
            '간편하게 구글메일을 연동하여 일정을 관리해보세요.',
            style: textTheme().displayMedium?.copyWith(fontSize: 15.sp),
          ),
          SizedBox(height: 200.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () async{
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
                    "Google 로그인으로 시작하기",
                    style: textTheme()
                        .displayLarge!
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
