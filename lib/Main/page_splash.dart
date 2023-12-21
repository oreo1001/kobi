// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:wonmo_calendar/Class/secure_storage.dart';
// import 'package:wonmo_calendar/GetController/auth_controller.dart';
// import 'package:wonmo_calendar/theme.dart';
//
// import 'Class/contact.dart';
// import 'http_request.dart';
//
// class SplashPage extends StatefulWidget {
//   SplashPage({super.key});
//
//   @override
//   _SplashPageState createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//   final storage = SecureStorage();
//   AuthController authController = Get.find();
//   String? token = '';
//
//   Future<void> login() async {
//     String? token = await authController.getToken();
//     await authController.loadUser();
//
//     String userId = authController.userId.value;
//     Map<String, dynamic> responseMap = await httpResponse('/auth/login', {'fcmToken': token, 'user': userId});
//
//     authController.contactList.value = convertDynamicListToContactList(responseMap['contactList']);
//     print('contactList: ${authController.contactList.value.toString()}');
//
//     if (responseMap['status'] != '200') {
//       Get.offNamed('/login');
//       return;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//       future: storage.getUserId(),
//       builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SplashWidget();
//         } else {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (snapshot.data != '' && snapshot.data != null) {
//               login().then((value) => Get.offAllNamed('/main'));
//             } else {
//               Get.offAllNamed('/login');
//             }
//           });
//           return Container(); // 빈 컨테이너로 잠시 반환
//         }
//       },
//     );
//   }
// }
//
// class SplashWidget extends StatelessWidget {
//   const SplashWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Image.asset('assets/images/logo.png', width: MediaQuery.of(context).size.width * 0.6, fit: BoxFit.contain),
//             SizedBox(
//               height: 30.h,
//             ),
//             Text('Wonmo Calendar',
//                 style: textTheme().displayLarge!.copyWith(color: Colors.deepPurpleAccent, fontSize: 50.sp))
//           ]),
//         ));
//   }
// }