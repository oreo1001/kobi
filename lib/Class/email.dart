class Email {
  final String threadId;
  final String emailAddress;
  final String name;
  final List<dynamic> messages;

  Email({
    required this.threadId,
    required this.emailAddress,
    required this.name,
    required this.messages,
  });
}

class Thread {
  bool isExpanded;
  final bool sentByUser;
  final String date;
  final String subject;
  final String body;

  Thread({
    required this.isExpanded,
    required this.sentByUser,
    required this.date,
    required this.subject,
    required this.body,
  });
}
