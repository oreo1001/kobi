import 'class_email.dart';

List<Thread> loadThreadListFromJson(List<dynamic> jsonList) {
  var threadList = jsonList.map((json) {
    return Thread(
      threadId: json['threadId'],
      emailAddress: json['emailAddress'],
      name: json['name'],
      messages: json['messages'],
    );
  }).toList();
  return threadList;
}

List<Message> parsingMessageListFromThread(List<dynamic> jsonList) {
  var messageList = jsonList.map((json) {
    return Message(
      sentByUser: json['sentByUser'],
      date: json['date'],
      subject: json['subject'],
      body: json['body'],
      messageId: json['messageId'],
      unread: json['unread'],
    );
  }).toList();
  return messageList;
}

int unreadMessageCount(List<Message> messageList) {
  int count = 0;
  for (var message in messageList) {
    if (message.unread) {
      count++;
    }
  }
  return count;
}