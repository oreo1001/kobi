import 'package:kobi/Calendar/methods/function_appointment_sheet.dart';
import 'package:kobi/Controller/appointment_controller.dart';
import 'package:kobi/Dialog/delete_dialog.dart';
import 'package:kobi/Dialog/event_dialog.dart';
import 'package:kobi/Dialog/update_event_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Class/class_my_event.dart';

void handleSilentEvent(List<Map<String, dynamic>> silentEvents, AppointmentController appointmentController) {
  for (Map<String, dynamic> silentEvent in silentEvents) {
    if (silentEvent['status'] == 'canceled') {
      MyEvent thisEvent = MyEvent.fromMap(silentEvent);
      appointmentController.deleteAppointment(myEventToAppointment(thisEvent));
      showDeleteDialog(thisEvent);
    } else {
      MyEvent thisEvent = MyEvent.fromMap(silentEvent);
      int index = appointmentController.myAppointments.indexWhere((appointment) => appointment.id == thisEvent.id);
      if (index == -1) {
        appointmentController.myAppointments.add(myEventToAppointment(thisEvent));
        showEventDialog(thisEvent);
      } else {
        Appointment beforeAppointment = appointmentController.myAppointments[index];  //업데이트 전 이벤트 불러오기
        appointmentController.updateAppointment(myEventToAppointment(thisEvent));
        showUpdateEventDialog(appointmentToMyEvent(beforeAppointment), thisEvent);
      }
    }
  }
}