import 'package:get/get.dart';

import '../Assistant/Class/step_details.dart';

class AssistantController extends GetxController {
  RxString assistantId = ''.obs;
  RxString threadId = ''.obs;
  RxString runId = ''.obs;
  RxString stepId = ''.obs;
  RxString status = 'initial'.obs;
  RxString type = ''.obs;

  final stepDetails = Rx<StepDetails?>(null);

  void loadAssistantFromJson(Map<String,dynamic> json) {
    assistantId.value = json['assistantId'] ?? '';
    threadId.value = json['threadId'] ?? '';
    runId.value = json['runId'] ?? '';
    status.value = json['status'] ?? '';
    stepId.value = json['stepId'] ?? '';
    type.value = json['type'] ?? '';
    stepDetails.value = json.containsKey('step_details') ? StepDetails.fromJson(json['step_details']) : null;
  }

  void printAll() {
    print('assistantId: ${assistantId.value}');
    print('threadId: ${threadId.value}');
    print('runId: ${runId.value}');
    print('status: ${status.value}');
    print('stepId: ${stepId.value}');
    print('type: ${type.value}');
    print('stepDetails: ${stepDetails.value}');
  }
}