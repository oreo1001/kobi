

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Calendar/methods/function_event_date.dart';
import '../function_http_request.dart';

class AppointmentController extends GetxController {
  RxList<Appointment> myAppointments = <Appointment>[Appointment(startTime: DateTime.utc(1998), endTime: DateTime.utc(1998))].obs;

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
      String summary;
      if(json['summary']==null || json['summary']=='') {
        summary='(제목 없음)';
      }else {
        summary= json['summary'];
      }
      return Appointment(
        id : json['id'],
        startTime: DateTime.parse(appointKSTDate(json['startTime'])),
        endTime: DateTime.parse(appointKSTEndDate(json['endTime'])),
        subject: summary,
        isAllDay: json['isAllDay'],
        notes: json['description'],
        location: json['location'],
        color : json['color'] ?? Colors.lightBlue, /// TODO json에서 Color 객체?
      );
    }).toList();
    return newAppointments;
  }
  void updateAppointment(Appointment updateAppointment) {
    int index = myAppointments.indexWhere((appointment) => appointment.id == updateAppointment.id);
    if (index != -1) {
      myAppointments[index] = Appointment(
        startTime: updateAppointment.startTime,
        endTime: updateAppointment.endTime,
        subject: updateAppointment.subject,
        id: updateAppointment.id,
        location: updateAppointment.location,
        notes: updateAppointment.notes,
        color: Colors.lightBlue,
        isAllDay: updateAppointment.isAllDay,
      );
    }
  }
  void deleteAppointment(Appointment deleteAppointment) {
    myAppointments.removeWhere((appointment) => appointment.id == deleteAppointment.id);
  }

  void deleteAppointmentById(String id) {
    myAppointments.removeWhere((appointment) => appointment.id == id);
  }
}