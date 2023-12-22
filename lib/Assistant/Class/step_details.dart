class StepDetails {
  final String? type;
  final List<MessageCreation>? messageCreation;
  final List<ToolCall>? toolCalls;

  StepDetails( {
    required this.type,
    this.messageCreation,
    this.toolCalls,
  });
  factory StepDetails.fromJson(Map<String, dynamic> json) {
    String type = json['type'];
    // messageCreation과 toolCalls 존재하면 파싱
    List<MessageCreation>? messageCreation;
    if (json.containsKey('message_creation') && json['message_creation'] != null) {
      messageCreation = (json['message_creation'] as List)
          .map((e) => MessageCreation.fromJson(e))
          .toList();
    }
    List<ToolCall>? toolCalls;
    if (json.containsKey('tool_calls')) {
      toolCalls = (json['tool_calls'] as List)
          .map((e) => ToolCall.fromJson(e))
          .toList();
    }
    return StepDetails(
      type: type,
      messageCreation: messageCreation,
      toolCalls: toolCalls,
    );
  }
}
class ToolCall{
  final String id;
  final String type;
  final ExFunction function;
  final String tts;

  ToolCall({
    required this.id,
    required this.type,
    required this.function,
    required this.tts,
  });
  factory ToolCall.fromJson(Map<String, dynamic> json){
    return ToolCall(
      id : json['id'],
      type : json['type'],
      function : ExFunction.fromJson(json['function']),
      tts : json['tts'],
    );
  }
}
class ExFunction {
  final String name;
  final Map<String,dynamic> arguments;

  ExFunction({
    required this.name,
    required this.arguments
  });
  factory ExFunction.fromJson(Map<String, dynamic> json){
    return ExFunction(
      name : json['name'],
      arguments : json['arguments'],
    );
  }
}

class MessageCreation {
  final String type;
  final dynamic text;
  final String tts;

  MessageCreation({
    required this.type,
    required this.text,
    required this.tts,
  });
  factory MessageCreation.fromJson(Map<String, dynamic> json){
    return MessageCreation(
      type : json['type'],
      text : json['text'],
      tts : json['tts'],
    );
  }
}