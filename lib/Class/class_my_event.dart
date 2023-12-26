import '../Calendar/function_event_date.dart';

class MyEvent {
  final String eventId;
  final String summary;
  final String startTime;
  final String endTime;
  final String? description;
  final String? location;

  MyEvent({
    required this.eventId,
    required this.summary,
    required this.startTime,
    required this.endTime,
    this.description,
    this.location,
  });

  factory MyEvent.fromMap(Map<String, dynamic> map) {
    return MyEvent(
      eventId: map['eventId'] ?? '',
      summary: map['summary'] ?? '',
      description: map['description'] ?? '',
      startTime: eventKSTDate(map['startTime']) ?? '',
      endTime: eventKSTDate(map['endTime']) ?? '',
      location: map['location'] ?? '',
    );
  }
}