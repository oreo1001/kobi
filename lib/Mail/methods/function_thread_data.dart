import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../class_email.dart';
import 'package:html/parser.dart' show parse;

List<Thread> loadThreadListFromJson(List<dynamic> jsonList) {
  var threadList = jsonList.map((json) {
    RxList<Message> messageList =
        parsingMessageListFromThread(json['messages']).obs;
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
      mimeType: json['mimeType'],
      snippet: json['snippet'],
    );
  }).toList();
  return messageList;
}

List<Thread> filterThreadListByFilter(
    RxList<Thread> threadList, String filter) {
  List<Thread> filteredThreadList = [];
  for (var thread in threadList) {
    if (filter == 'All') {
      filteredThreadList.add(thread);
    } else if (filter == 'Business') {
      if (thread.labelList.contains('careebee_Business')) {
        filteredThreadList.add(thread);
      }
    } else if (filter == 'Notifications') {
      if (thread.labelList.contains('careebee_Notifications')) {
        filteredThreadList.add(thread);
      }
    } else if (filter == 'Newsletters') {
      if (thread.labelList.contains('careebee_Newsletters')) {
        filteredThreadList.add(thread);
      }
    } else if (filter == 'Finance') {
      if (thread.labelList.contains('careebee_Finance')) {
        filteredThreadList.add(thread);
      }
    } else if (filter == 'Unknown') {
      if (thread.labelList.contains('careebee_Unknown')) {
        filteredThreadList.add(thread);
      }
    }
  }
  return filteredThreadList;
}

RxList<Message> markAllAsRead(List<Message> messages) {
  List<Message> newMessages = [];
  for (var message in messages) {
    if (message.unread) {
      message = Message(
        sentByUser: message.sentByUser,
        date: message.date,
        subject: message.subject,
        body: message.body,
        messageId: message.messageId,
        unread: false,
        snippet: message.snippet,
      );
    }
    newMessages.add(message);
  }
  return newMessages.obs;
}

RxList<RxList<String>> unreadMessageIdListsInThreads(List<Thread> threadList) {
  RxList<RxList<String>> unreadMessageIdLists = <RxList<String>>[].obs;
  for (var thread in threadList) {
    RxList<String> unreadMessageIdList = <String>[].obs;
    for (var message in thread.messages) {
      if (message.unread) {
        unreadMessageIdList.add(message.messageId);
      }
    }
    unreadMessageIdLists.add(unreadMessageIdList);
  }
  return unreadMessageIdLists;
}

String firstSentenceFromHtml(Message message) {
  String firstSentence = '';
  if (message.mimeType != "text/plain") {
    var document = parse(message.body);
    String parsedString = document.body!.text.trim();

    RegExp exp = RegExp(r'[^.!?]*[.!?]');
    Match? match = exp.firstMatch(parsedString);

    if (match != null) {
      firstSentence = match.group(0)!;
    }
  }
  return firstSentence;
}
