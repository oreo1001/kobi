import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Alarm/page_alarm.dart';
import 'package:kobi/Calendar/calendar_app.dart';

import 'Assistant/page_assistant.dart';
import 'Mail/page_email.dart';
import 'User/page_user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _widgetOptions = const <Widget>[
    AssistantPage(),
    CalendarPage(),
    MailPage(),
    AlarmPage(null),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _widgetOptions.length,
        child: Scaffold(
          body: Column(children: [
            Expanded(child: TabBarView(children: _widgetOptions)),
            Divider(
              height: 2,
              color: Colors.grey.shade400,
            ),
            Container(
              height: 70.h,
              color: Colors.white,
              child: TabBar(
                unselectedLabelColor: Colors.grey.shade400,
                labelColor: Colors.black,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: Icon(Icons.home,size: 28.sp,)),
                  Tab(icon: Icon(Icons.calendar_today,size: 28.sp,)),
                  Tab(icon: Icon(Icons.mail,size: 28.sp,)),
                  Tab(icon: Icon(Icons.alarm,size: 28.sp,)),
                  Tab(icon: Icon(Icons.person,size: 28.sp,)),
                ],
              ),
            ),
          ]),
        ));
  }
}
