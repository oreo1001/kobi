import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Alarm/page_alarm.dart';
import 'package:kobi/Calendar/page_calendar.dart';
import 'package:kobi/Controller/recorder_controller.dart';
import 'package:kobi/Assistant/microphone_button.dart';

import '../Assistant/page_assistant.dart';
import '../Mail/page_email.dart';
import '../User/page_user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 1;
  Key _calendarPageKey = UniqueKey();
  Key _mailPageKey = UniqueKey();

  void _rebuildCalendarPage() {
    setState(() {
      _calendarPageKey = UniqueKey();
    });
  }

  void _rebuildMailPageKey() {
    setState(() {
      _mailPageKey = UniqueKey();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
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
                children: [
                  const AssistantPage(),
                  CalendarPage(key: _calendarPageKey,),
                  MailPage(key: _mailPageKey,),
                  // const AlarmPage(null),
                  const UserPage(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: MicroPhoneButton(),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.alarm),
          //   label: '',
          // ),
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
