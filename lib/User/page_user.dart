import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    String? name = '동근';
    String? email = 'test@email.com';
    return Scaffold(
        body: ListView(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30.sp),
                child: Image.network(
                  'http://media-cdn.tripadvisor.com/media/photo-o/1b/e0/a0/0e/photo0jpg.jpg',
                  fit: BoxFit.fill,
                ), // Text(key['title']),
              ),
              title: Text(name ?? ''),
              subtitle: Text(email ?? ''),
              trailing: Container(
                width: 90.w,
                child: ElevatedButton(
                  // style: ElevatedButton.styleFrom(minimumSize: Size(60.w,40.h)),
                  onPressed: (){},
                  child: Text('로그아웃',
                      style:
                      textTheme().displayMedium?.copyWith(fontSize: 12.sp)),
                ),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('나의 코드',
                                style: textTheme().displaySmall!.copyWith(
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(
                              'mycode',
                              style: textTheme().displaySmall!.copyWith(
                                  fontSize: 15.sp,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.copy,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 20.w,
                            )
                          ],
                        )),
                  ),
                  myTextButton(() {
                    // Share.share('https://careebe.page.link/rKBn');
                  },
                      "앱 공유하기",
                      textTheme().displaySmall!.copyWith(
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  myTextButton(
                          () {},
                      "개인정보 처리방침",
                      textTheme().displaySmall!.copyWith(
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 50.h,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('버전 정보',
                                style: textTheme().displaySmall!.copyWith(
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(
                              '2.0.3',
                              style: textTheme().displaySmall!.copyWith(
                                  fontSize: 15.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 20.h),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/localAlarm');
                    },
                    child: Text("알람")),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/drag');
                    },
                    child: Text("drag")),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/eleven');
                    },
                    child: Text("일레븐랩")),
              ],
            ),
          ],
        ));
  }

  myTextButton(VoidCallback onPressed, String text, TextStyle textStyle) {
    return SizedBox(
      height: 60.h,
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
              Container(child: Text(text, style: textStyle)),
              const Spacer(),
            ],
          )),
    );
  }
}
