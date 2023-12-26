enum AssistantFunction {
  messageCreation(num:0, value: 'message_creation'),
  createEmail(num: 1, value:'create_email'),
  describeUserQuery(num: 2, value:'describe_user_query'),
  multipleChoiceQuery(num: 3, value: 'multiple_choice_query'),
  insertEvent(num: 4, value: 'insert_event'),
  patchEvent(num:5 ,value : 'patch_event'),
  deleteEvent(num:6, value: 'delete_event'),
  getFreeBusy(num: 7, value:'get_freebusy'),
  establishStrategy(num: 8, value:'establish_strategy');

  final int num;
  final String value;

  const AssistantFunction({
    required this.num,
    required this.value,
  });
}