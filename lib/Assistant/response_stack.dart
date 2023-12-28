import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kobi/Controller/recorder_controller.dart';

class MyStackWidget extends StatefulWidget {
  const MyStackWidget({super.key, required this.currentWidget});


  final List<Widget> currentWidget;

  @override
  _MyStackWidgetState createState() => _MyStackWidgetState();
}

class _MyStackWidgetState extends State<MyStackWidget> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  RecorderController recorderController = Get.put(RecorderController());

  List<String> previousTranscription = [''];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void removeTopWidget() {
    _controller.forward().then((_) {
      setState(() {
        if (widget.currentWidget.isNotEmpty) {
          widget.currentWidget.removeLast();
        }
      });
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          List<String> responseList =  recorderController.transcription;
          print('response_stack$responseList');

          bool equal = !const ListEquality().equals(previousTranscription, responseList);
          if (equal) {
            previousTranscription = responseList;
            removeTopWidget();
          }

          return const SizedBox();
        }),
        widget.currentWidget.isEmpty
            ? const SizedBox()
            :
        Stack(
          children: widget.currentWidget.map((widget) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return child!;
              },
              child: widget,
            );
          }).toList(),
        ),
      ],
    );
  }
}
