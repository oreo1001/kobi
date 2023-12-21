import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kobi/Assistant/ResponseWidgets/test_controller.dart';

class TestFloatingActionButton extends StatelessWidget {
  TestFloatingActionButton({super.key});

  TestController testController = Get.put(TestController());

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      if (testController.testValue.value == 0) {
        testController.testValue.value = 1;
      }
      else if (testController.testValue.value == 1) {
        testController.testValue.value = 2;
      }
      else if (testController.testValue.value == 2) {
        testController.testValue.value = 3;
      }
      else {
        testController.testValue.value = 0;
      }
    });
  }
}
