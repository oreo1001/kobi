import 'package:flutter/material.dart';
import 'package:kobi/Calendar/page_calendar.dart';
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

  int _selectedIndex = 0;
  final List <Widget> _pageList =  [
    const AssistantPage(),
    CalendarPage(),
    MailPage(),
    const UserPage(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      print("index : $index");
      if (index == 1) {
        // delete previous page

        _pageList.removeAt(1);
        _pageList.insert(1, CalendarPage(key: UniqueKey()));
      }
      if (index == 2) {
        _pageList.removeAt(2);
        _pageList.insert(2, MailPage(key: UniqueKey()));
      }
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
                children: _pageList
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: MicroPhoneButton(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
