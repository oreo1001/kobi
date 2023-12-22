import 'class_email.dart';

List<Email> loadEmailsFromJson(List<dynamic> jsonList) {
  var newEmails = jsonList.map((json) {
    return Email(
      threadId: json['threadId'],
      emailAddress: json['emailAddress'],
      name: json['name'],
      messages: json['messages'],
    );
  }).toList();
  return newEmails;
}

List<Thread> parsingThreadsFromEmail(List<dynamic> jsonList) {
  var newThreads = jsonList.map((json) {
    return Thread(
      isExpanded: false,
      sentByUser: json['sentByUser'],
      date: json['date'],
      subject: json['subject'],
      body: json['body'],
    );
  }).toList();
  return newThreads;
}