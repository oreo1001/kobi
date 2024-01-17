import '../Calendar/methods/function_event_date.dart';

class MyEvent {
  final String? id;
  final String summary;
  final String startTime;
  final String endTime;
  final String? description;
  final String? location;
  bool isAllDay;

  MyEvent({
    this.id,
    required this.summary,
    required this.startTime,
    required this.endTime,
    this.description,
    this.location,
    required this.isAllDay,
  });

  factory MyEvent.fromMap(Map<String, dynamic> map) {
    String summary;
    if(map['summary']==null || map['summary']=='') {
      summary='(제목 없음)';
    }else{
      summary=map['summary'];
    }
    return MyEvent(
      id: map['id'] ?? '',
      summary: summary,
      description: map['description'] ?? '',
      startTime: appointKSTDate(map['startTime'] ?? ''),
      endTime: appointKSTEndDate(map['endTime']) ?? '',
      location: map['location'] ?? '',
      isAllDay: map['isAllDay'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary,
      'startTime': DateTime.parse(startTime).toIso8601String(),
      'endTime': DateTime.parse(endTime).toIso8601String(),
      'description': description,
      'location': location,
      'isAllDay': isAllDay
    };
  }
}
