import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kobi/in_app_notification/in_app_notification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Class/secure_storage.dart';
import '../Controller/auth_controller.dart';
import '../theme.dart';
import 'Widgets/my_info_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  Future<void> _handleSignOut() async {
    final storage = SecureStorage();
    GoogleSignIn googleSignIn = GoogleSignIn();

    await storage.setUser({
      'userId': '',
      'displayName': '',
      'email': '',
      'photoUrl': '',
    });
    await googleSignIn.signOut();
    Get.offNamed('/login');
  }

  AuthController authController = Get.find();

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
                        child: CachedNetworkImage(
                          imageUrl: photoUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      title: Text(name,style: textTheme().bodySmall?.copyWith(fontSize: 20.sp, color: Colors.grey.shade800)),
                      subtitle: Text(email,style: textTheme().bodySmall?.copyWith(fontSize: 14.sp, color: Colors.grey.shade500)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height : 10.h),
            // myInfoButton(() {
            //   // Share.share('https://careebe.page.link/rKBn');
            //   //동적 딥링크 만들기
            // },
            //     "앱 공유하기",
            //     textTheme().displaySmall!.copyWith(
            //         fontSize: 18.sp,
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500)),
            myInfoButton(
                    () async{
                      if (!await launchUrl(Uri.parse('https://www.notion.so/jungwon423/466000cf0e6241f8bacbb9cffc746d47'))) {
                      throw "Could not launch url";
                      }
                    },
                "개인정보 처리방침",
                textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            Container(
              padding: EdgeInsets.symmetric(horizontal : buttonPadding,vertical: 5.h),
              height: buttonHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('버전 정보',
                      style: textTheme().displaySmall!.copyWith(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  Text(
                    '1.0.0',
                    style: textTheme().displaySmall!.copyWith(
                        fontSize: 18.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            myInfoButton(
                    () {
                  _handleSignOut();
                },
                "로그아웃",
                textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            myInfoButton(
                    () {
                      Future.delayed(Duration.zero).then((_) {
                        InAppNotification.show(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: Colors.grey[100]!),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                child : Text('메일을 작성 중이에요 ...', style: textTheme().displaySmall,)
                            ),
                            duration: const Duration(seconds: 60), context: context);
                      });
                      // Get.toNamed('/test');
                },
                "테스트",
                textTheme().displaySmall!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ],
        ));
  }
}
