import '../Calendar/methods/function_event_date.dart';

class Event {
  final String eventId;
  final String summary;
  final String startTime;
  final String endTime;
  final String? description;
  final String? location;

  Event({
    required this.eventId,
    required this.summary,
    required this.startTime,
    required this.endTime,
    this.description,
    this.location,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['eventId'] ?? '',
      summary: map['summary'] ?? '',
      description: map['description'] ?? '',
      startTime: eventKSTDate(map['startTime']),
      endTime: eventKSTDate(map['endTime']),
      location: map['location'] ?? '',
    );
  }
}