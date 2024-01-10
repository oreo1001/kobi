

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Calendar/methods/function_event_date.dart';
import '../Class/class_my_event.dart';
import '../function_http_request.dart';

class AppointmentController extends GetxController {
  RxList<Appointment> myAppointments = <Appointment>[].obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getAppointments(); // 페이지 로드될 때 데이터 로드
  // }

  Future getAppointments() async {
    Map<String, dynamic> responseMap = await httpResponse('/calendar/eventList', {});
    List<Appointment> tempAppointments = [];
    for (Map data in responseMap['data']) {
      if (data['summary'] == 'primary' ||
          data['summary'] == 'WonMoCalendar') {
        tempAppointments.addAll(loadAppointmentsFromJson(data['eventList']));
      }
    }
    myAppointments.value = tempAppointments;
  }

  List<Appointment> loadAppointmentsFromJson(List<dynamic> jsonList) {
    var newAppointments = jsonList.map((json) {
      bool isAllDay = json['isAllDay'];
      return Appointment(
        // id : json['id'],
        startTime: DateTime.parse(appointKSTDate(json['startTime'], isAllDay)),
        endTime: DateTime.parse(appointKSTDate(json['endTime'], isAllDay)),
        subject: json['summary'] ?? '',
        isAllDay: json['isAllDay'],
        notes: json['description'],
        location: json['location'],
        color : json['color'] ?? Colors.lightBlue, /// TODO json에서 Color 객체?
      );
    }).toList();
    return newAppointments;
  }
  void updateAppointmentFromMap(Map<String, dynamic> map){   //FirebaseMessaging
    MyEvent myEvent = MyEvent.fromMap(map);
    Appointment newAppointment = Appointment(
      startTime: DateTime.parse(myEvent.startTime),
      endTime: DateTime.parse(myEvent.endTime),
      subject: myEvent.summary,
      id: myEvent.eventId, //eventId -> id
      location: myEvent.location,
      notes: myEvent.description,
      color: Colors.lightBlue, // 색상은 예시로 lightBlue
    );
    myAppointments.add(newAppointment);
  }

  void updateAppointment(Appointment myAppointment) {
    int index = myAppointments.indexWhere((appointment) => appointment.id == myAppointment.id);
    print(index);
    if (index != -1) {
      myAppointments[index] = Appointment(
        startTime: myAppointment.startTime,
        endTime: myAppointment.endTime,
        subject: myAppointment.subject,
        id: myAppointment.id,
        location: myAppointment.location,
        notes: myAppointment.notes,
        color: Colors.lightBlue,
      );
    }
  }
  ///TODO  delete Appointment 구현
}