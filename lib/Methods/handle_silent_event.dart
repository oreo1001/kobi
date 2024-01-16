import 'package:kobi/Controller/appointment_controller.dart';

void handleSilentEvent(List<dynamic> silentEvents, AppointmentController appointmentController) {
  for (Map<String, dynamic> silentEvent in silentEvents) {
    if (silentEvent['deleted']) {
      appointmentController.myAppointments.removeWhere((appointment) => appointment.id == silentEvent['id']);
    } else {
      int index = appointmentController.myAppointments.indexWhere((appointment) => appointment.id == silentEvent['id']);
      if (index == -1) {
        appointmentController.addAppointmentFromMap(silentEvent);
      } else {
        appointmentController.updateAppointmentFromMap(silentEvent);
      }
    }
  }
}