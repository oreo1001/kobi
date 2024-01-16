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
    );
  }).toList();
  return messageList;
}

List<Thread> filterThreadListByFilter(
    RxList<Thread> threadList, String filter) {
  List<Thread> filteredThreadList = [];
  for (var thread in threadList) {
    if (filter == '전체 메일함') {
      filteredThreadList.add(thread);
    }
    //  else if (filter == 'WonMoMeeting 메일함') {
    //   if (thread.labelList.contains('WonMoMeeting')) {
    //     filteredThreadList.add(thread);
    //   }
    else if (filter == '프로모션 메일함') {
      if (!thread.labelList.contains('WonMoMeeting')) {
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

String firstSentenceFromHtml(Message message){
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