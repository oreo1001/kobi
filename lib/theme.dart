import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      textTheme: textTheme(),
      appBarTheme: appbarTheme(),
      primaryColor: Colors.white);
}

TextTheme textTheme() {
  return TextTheme(
    bodySmall: TextStyle(letterSpacing: 0.sp,fontFamily: 'NotoSansKR', fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(letterSpacing: 0.sp,fontFamily: 'NotoSansKR', fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(letterSpacing: 0.sp,fontFamily: 'NotoSansKR', fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.w700),
    displaySmall: TextStyle(letterSpacing: -0.5.sp,fontFamily: 'NotoSansKR', fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w500),
    displayMedium: TextStyle(letterSpacing: -0.5.sp,fontFamily: 'NotoSansKR', fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w600),
    displayLarge: TextStyle(letterSpacing: -0.5.sp,fontFamily: 'NotoSansKR', fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontFamily: 'NotoSansKR', fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w300),
    headlineSmall: TextStyle(fontFamily: 'NotoSansKR', fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w100),
  );
}

AppBarTheme appbarTheme() {
  return AppBarTheme(
    centerTitle: false,
    color: Colors.white,
    elevation: 0.0,
    titleTextStyle: GoogleFonts.nanumGothic(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );
}