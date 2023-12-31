class Thread {
  final String threadId;
  final String emailAddress;
  final String name;
  final List<dynamic> messages;

  Thread({
    required this.threadId,
    required this.emailAddress,
    required this.name,
    required this.messages,
  });
}

class Message {
  final bool sentByUser;
  final String date;
  final String subject;
  final String body;
  final String messageId;
  final bool unread;

  Message({
    required this.sentByUser,
    required this.date,
    required this.subject,
    required this.body,
    required this.messageId,
    required this.unread,
  });
}
