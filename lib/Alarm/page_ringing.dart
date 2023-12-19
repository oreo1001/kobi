import 'package:flutter/material.dart';

class RingingPage extends StatefulWidget {
  RingingPage(String? payload, {Key? key}) : super(key: key);
  String? payload;

  @override
  State<RingingPage> createState() => _RingingPageState();
}

class _RingingPageState extends State<RingingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body : Text(widget.payload ?? ''));
  }
}