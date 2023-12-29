import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Class/secure_storage.dart';
import '../Controller/auth_controller.dart';
import '../theme.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  AuthController authController = Get.find();
  final storage = SecureStorage();
  Map<String, String> initialUser = {
    'userId': '',
    'displayName': '',
    'email': '',
    'photoUrl': '',
  };

  Future<void> _handleSignOut() async {
    await storage.setUser(initialUser);
    Get.offNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    String name = authController.name.value;
    String email = authController.email.value;
    String photoUrl = authController.photoUrl.value;
    double buttonHeight = 50.h;
    double buttonPadding = 30.w;
    return Scaffold(
        body: ListView(
          children: [
            Container(
              color: const Color(0xffFCFCFC),
              height: 140.h,
              child: Column(
                children: [
                  SizedBox(height:40.h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w,0,0,0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30.sp),
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.fill,
                        ), // Text(key['title']),
                      ),
                      title: Text(name ?? '',style: textTheme().bodySmall?.copyWith(fontSize: 20.sp, color: Colors.grey.shade800)),
                      subtitle: Text(email ?? '',style: textTheme().bodySmall?.copyWith(fontSize: 14.sp, color: Colors.grey.shade500)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height : 10.h),
            SizedBox(
              height: buttonHeight,
              child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      )),
                  onPressed: () async {
                    // FlutterClipboard.copy('mycode').then((value) => print('copied'));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonPadding,vertical: 5.h),
                    child: Row(
                      children: [
                        Text('나의 코드',
                            style: textTheme().displaySmall!.copyWith(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width : 20.w),
                        Text(
                          'mycode',
                          style: textTheme().displaySmall!.copyWith(
                              fontSize: 16.sp,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.copy,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  )),
            ),
            myTextButton(() {
              // Share.share('https://careebe.page.link/rKBn');
            },
                "앱 공유하기",
                textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            myTextButton(
                    () {},
                "개인정보 처리방침",
                textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            Container(
              padding: EdgeInsets.symmetric(horizontal : buttonPadding,vertical: 5.h),
              height: buttonHeight,
              child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      )),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('버전 정보',
                          style: textTheme().displaySmall!.copyWith(
                              fontSize: 18.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Text(
                        '2.0.3',
                        style: textTheme().displaySmall!.copyWith(
                            fontSize: 18.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )),
            ),
            myTextButton(
                    () {
                  _handleSignOut();
                },
                "로그아웃",
                textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ],
        ));
  }

  myTextButton(VoidCallback onPressed, String text, TextStyle textStyle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 5.h),
      child: SizedBox(
        height: 50.h,
        child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0.sp, 0.sp),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey.shade800,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                )),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(text, style: textStyle),
                const Spacer(),
              ],
            )),
      ),
    );
  }
}
