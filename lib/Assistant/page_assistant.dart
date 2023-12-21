import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kobi/Assistant/ResponseWidgets/default.dart';
import 'package:kobi/Assistant/ResponseWidgets/response_animation.dart';
import 'package:kobi/Assistant/ResponseWidgets/test1.dart';
import 'package:kobi/Assistant/ResponseWidgets/test_controller.dart';

import 'ResponseWidgets/test2.dart';
import 'ResponseWidgets/test3.dart';
class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State< AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State< AssistantPage> {
  TestController testController = Get.put(TestController());

  Widget currentWidget = DefaultResponse() ;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("testValue: ${testController.testValue.value}");
      int testValue  = testController.testValue.value;
      changeWidget(testValue);
      return currentWidget;});
  }

  void changeWidget(int testValue) {
    if (testValue == 0) {
      currentWidget = SlideFromLeftAnimation(
          child: DefaultResponse());
    }
    else if (testValue == 1) {
      currentWidget = SlideFromLeftAnimation(child: Test1());
    }
    else if (testValue == 2) {
      currentWidget = Test2();
    }
    else {
      currentWidget = Test3();
    }
  }
}