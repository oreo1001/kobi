class Contact {
  String emailAddress;
  String name;

  Contact({
    required this.emailAddress,
    required this.name,
  });

  @override
  String toString() {
    return '{emailAddress: $emailAddress, name: $name}';
  }
}

List<Contact> convertDynamicListToContactList(List<dynamic> dynamicList) {
  return dynamicList.map((item) {
    return Contact(
      emailAddress: item['emailAddress'], // 'item'은 dynamic 형식이므로 필드에 직접 접근합니다.
      name: item['name'],
    );
  }).toList();
}