import 'package:flutter/material.dart';
import 'package:kobi/Assistant/home_widget.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State< AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State< AssistantPage> {

  @override
  Widget build(BuildContext context) {
      return const Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            HomeWidget()
          ]),
        ),
      );
  }
}