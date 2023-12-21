import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kobi/Alarm/page_alarm.dart';
import 'package:kobi/Calendar/calendar_app.dart';
import 'package:kobi/Controller/recorder_controller.dart';

import 'Assistant/page_assistant.dart';
import 'Mail/page_email.dart';
import 'User/page_user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  // final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RecorderController recorderController = Get.put(RecorderController());

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const AssistantPage(),
    const CalendarPage(),
    const MailPage(),
    const AlarmPage(null),
    const UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    recorderController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Center(
              child: IndexedStack(
                index: _selectedIndex,
                children: _widgetOptions,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xff8B2CF5),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}