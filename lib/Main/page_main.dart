import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kobi/Calendar/page_calendar.dart';
import 'package:kobi/Main/microphone_button.dart';

import '../Assistant/page_assistant.dart';
import '../Class/class_my_event.dart';
import '../Dialog/delete_dialog.dart';
import '../Dialog/event_dialog.dart';
import '../Dialog/update_event_dialog.dart';
import '../Mail/page_mail.dart';
import '../User/page_user.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../function_firebase_message.dart';


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

  void _handleMessage(RemoteMessage message) {
    Map <String, dynamic> data = message.data;
    setState(() {
      _selectedIndex = 1;
    });
    String type = data['type'];
    switch (type) {
      case 'insert_event':
        showEventDialog(MyEvent.fromMap(data));
        break;
      case 'update_event':
        showUpdateEventDialog(MyEvent.fromMap(jsonDecode(data["before_event"])), MyEvent.fromMap(jsonDecode(data["after_event"])));
        break;
      case 'delete_event':
        showDeleteDialog(MyEvent.fromMap(data));
        break;
    }
  }


  void _onItemTapped(int index) {
    setState(() {
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
    if (Platform.isAndroid) {
      initializeAndroidForegroundMessaging(_handleMessage);
    }
    if (Platform.isIOS) {
      initializeIosForegroundMessaging(_handleMessage);
    }
    setupInteractedMessage(_handleMessage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
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
      ),
      floatingActionButton: MicroPhoneButton(),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.black,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail_outlined,
            ),
            label: 'mail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'myInfo',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
