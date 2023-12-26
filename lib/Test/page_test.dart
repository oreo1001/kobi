import 'package:flutter/material.dart';
import '../Class/class_my_event.dart';
import '../function_http_request.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Future<List<MyEvent>> futureEvents;
  Future<List<MyEvent>> fetchEvents() async {
    Map<String, dynamic> responseMap = await httpResponse('/calendar/eventList', {});
    if (responseMap['statusCode'] == 200) {
      List<MyEvent> events = responseMap['eventList'].map((event) => MyEvent.fromMap(event)).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }
  Future<List<MyEvent>> test() async{
    DateTime now = DateTime.now();
    MyEvent testEvent = MyEvent(
      eventId: 'dfgdfg',
      summary: '중요한 약속이다.',
      startTime: now.toIso8601String(),
      endTime: now.toIso8601String(),
      location: 'sgdsgsg',
      description: 'sdgdsgsdgsdg',
    );
    List<MyEvent> events = [];
    events.add(testEvent);
    events.add(testEvent);
    return events;
  }

  @override
  void initState() {
    super.initState();
    futureEvents = test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: FutureBuilder<List<MyEvent>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].summary),
                  subtitle: Text('${snapshot.data![index].startTime} ~ ${snapshot.data![index].endTime}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
