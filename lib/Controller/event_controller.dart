import 'package:get/get.dart';
import '../Class/class_my_event.dart';

class EventController extends GetxController {
  RxString type = ''.obs;
  Rx<MyEvent> beforeEvent = Rx<MyEvent>(MyEvent(
    eventId: '',
    summary: '',
    startTime: '',
    endTime: '',
    location: '',
    description: '',
  ));
  Rx<MyEvent> currentEvent = Rx<MyEvent>(MyEvent(
    eventId: '',
    summary: '',
    startTime: '',
    endTime: '',
    location: '',
    description: '',
  ));
  Rx<MyEvent> deleteEvent = Rx<MyEvent>(MyEvent(
    eventId: '',
    summary: '',
    startTime: '',
    endTime: '',
    location: '',
    description: '',
  ));

  void setBeforeEvent(Map<String, dynamic> eventMap) {
    beforeEvent.value = MyEvent.fromMap(eventMap);
  }
  void setCurrentEvent(Map<String, dynamic> eventMap) {
    currentEvent.value = MyEvent.fromMap(eventMap);
  }
  void setDeleteEvent(Map<String,dynamic> eventMap){
    deleteEvent.value = MyEvent.fromMap(eventMap);
  }
}