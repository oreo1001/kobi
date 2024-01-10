import 'package:kobi/Assistant/Class/step_details.dart';

class AssistantResponse {
  String assistantId = '';
  String threadId = '';
  String runId = '';
  String stepId = '';
  String status = 'initial';
  String type = '';
  StepDetails? stepDetails;

  AssistantResponse({
    required this.assistantId,
    required this.threadId,
    required this.runId,
    required this.stepId,
    required this.status,
    required this.type,
    this.stepDetails,
  });

  void fromJson(Map<String,dynamic> json) {
    assistantId = json['assistantId'] ?? '';
    threadId = json['threadId'] ?? '';
    runId = json['runId'] ?? '';
    status = json['status'] ?? '';
    stepId = json['stepId'] ?? '';
    type = json['type'] ?? '';
    stepDetails = json.containsKey('step_details') ? StepDetails.fromJson(json['step_details']) : null;
  }

  void printAll() {
    print('assistantId: $assistantId');
    print('threadId: $threadId');
    print('runId: $runId');
    print('status: $status');
    print('stepId: $stepId');
    print('type: $type');
    print('stepDetails: $stepDetails');
  }

}