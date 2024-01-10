import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../class_email.dart';

List<Thread> loadThreadListFromJson(List<dynamic> jsonList) {
  var threadList = jsonList.map((json) {
    RxList<Message> messageList = parsingMessageListFromThread(json['messages']).obs;
    return Thread(
      threadId: json['threadId'],
      emailAddress: json['emailAddress'],
      name: json['name'],
      messages: messageList,
      labelList: json['labelList'],
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

List <String> unreadMessageIdList(List<Message> messageList) {
  List <String> unreadMessageIdList = [];
  for (var message in messageList) {
    if (message.unread) {
      unreadMessageIdList.add(message.messageId);
    }
  }
  return unreadMessageIdList;
}

List<Thread> filterThreadListByFilter(RxList<Thread> threadList, String filter) {
  List<Thread> filteredThreadList = [];
  for (var thread in threadList) {
    if (filter == '전체 메일함') {
      filteredThreadList.add(thread);
    } else if (filter == 'WonMoMeeting 메일함') {
      if (thread.labelList.contains('WonMoMeeting')) {
        filteredThreadList.add(thread);
      }
  } else if (filter == '프로모션 메일함') {
      if (!thread.labelList.contains('WonMoMeeting')) {
        filteredThreadList.add(thread);
      }
    }
  }
  return filteredThreadList;
}

void markAllAsRead(List<Message> messages) {
  for (var message in messages) {
    if (message.unread) {
      message = Message(
        sentByUser: message.sentByUser,
        date: message.date,
        subject: message.subject,
        body: message.body,
        messageId: message.messageId,
        unread: false,
      );
    }
  }
}