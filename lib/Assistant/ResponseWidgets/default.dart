import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/theme.dart';

class DefaultResponse extends StatelessWidget {
  const DefaultResponse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
          child: Column(
            children: [
              SizedBox(height: 87.h),
              Text('당신 곁에 언제나',
                  style: textTheme().displaySmall!.copyWith(
                      fontSize: 32.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
              Text('커리비',
                  style: textTheme().displayMedium!.copyWith(
                      fontSize: 35.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 70.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text("'커리비'를 불러서 이렇게 말해보세요",
                    style: textTheme().displaySmall!.copyWith(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                    height: 60.h,
                    width : 353.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          backgroundColor: Colors.grey.shade100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.sp))),
                      onPressed: () {},
                      child: Text("이번 주 일정 알려줘",
                          style: textTheme().displaySmall!.copyWith(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                    height: 60.h,
                    width : 353.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          backgroundColor: Colors.grey.shade100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.sp))),
                      onPressed: () {},
                      child: Text("김부장님께 메일 보내줘",
                          style: textTheme().displaySmall!.copyWith(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                    height: 66.h,
                    width : 353.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          backgroundColor: Colors.grey.shade100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.sp))),
                      onPressed: () {},
                      child: Text("목요일 권대표님과의 일정 6시로 바꿔줘",
                          style: textTheme().displaySmall!.copyWith(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    )),
              ),
            ],
          ),
        ));
  }
}
