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

  @override
  String toString() {
    return 'Thread(threadId: $threadId, emailAddress: $emailAddress, name: $name, messages: $messages)';
  }
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

  @override
  String toString() {
    return 'Message(sentByUser: $sentByUser, date: $date, subject: $subject, body: $body, messageId: $messageId, unread: $unread)';
  }
}

class TestMail{
  final String title;
  final String body;
  final String emailAddress;
  final bool reply;

  TestMail({
    required this.title,
    required this.body,
    required this.emailAddress,
    required this.reply,
  });

  factory TestMail.fromMap(Map<String, dynamic> map) {
    return TestMail(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      emailAddress: map['emailAddress'] ?? '',
      reply: map['reply'] ?? false,
    );
  }
}