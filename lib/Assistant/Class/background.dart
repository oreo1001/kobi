import 'package:kobi/Class/class_my_event.dart';

class Background {
  final MailFiltering mailFiltering;
  final List<AutoCalendar> autoCalendarList;

  Background({
    required this.mailFiltering,
    required this.autoCalendarList,
  });
}

class MailFiltering {
  final String log;
  final String date;

  MailFiltering({
    required this.log,
    required this.date,
  });
}

class AutoCalendar {
  final String date;
  final Mail mail;
  final MyEvent event;
  final String log;

  AutoCalendar({
    required this.date,
    required this.mail,
    required this.event,
    required this.log,
  });
}

class Mail {
  final String emailAddress;
  final String body;
  final String subject;

  Mail({
    required this.emailAddress,
    required this.body,
    required this.subject,
  });
}


Background loadBackgroundFromJson(Map<String, dynamic> json) {
  return Background(
    mailFiltering: MailFiltering(
      log: json['mailFiltering']['log'],
      date: json['mailFiltering']['date'],
    ),
    autoCalendarList: loadAutoCalendarListFromJson(json['autoCalendar']),
  );
}

List<AutoCalendar> loadAutoCalendarListFromJson(List<dynamic> jsonList) {
  var autoCalendarList = jsonList.map((json) {
    return AutoCalendar(
      date: json['date'],
      mail: Mail(
        emailAddress: json['mail']['emailAddress'],
        body: json['mail']['body'],
        subject: json['mail']['subject'],
      ),
      event: MyEvent.fromMap(json['event']),
      log: json['log'],
    );
  }).toList();
  return autoCalendarList;
}