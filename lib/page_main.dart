import 'package:flutter/material.dart';
import 'package:kobi/Alarm/page_alarm.dart';
import 'package:kobi/Calendar/calendar_app.dart';

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
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    AssistantPage(),
    CalendarPage(),
    MailPage(),
    AlarmPage(null),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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