class APIResponse {
  final String assistantId;
  final String stepId;
  final String threadId;
  final String runId;
  final String beforeType;
  final dynamic functionResponses;

  APIResponse( {
    required this.assistantId,
    required this.stepId,
    required this.threadId,
    required this.runId,
    required this.beforeType,
    this.functionResponses,
  });
  Map<String, dynamic> toJson() {
    return {
      'assistantId': assistantId,
      'stepId': stepId,
      'threadId': threadId,
      'runId': runId,
      'beforeType': beforeType,
      'functionResponses': functionResponses, // 이미 JSON 형식이거나 toJson을 구현해야 함
    };
  }
}

class ToolOutput{
  final String toolCallId;
  final String name;
  var output;

  ToolOutput({
    required this.toolCallId,
    required this.output,
    required this.name,
  });
  Map<String, dynamic> toJson() {
    return {
      'tool_call_id': toolCallId,
      'name' : name,
      'output': output,
    };
  }
}