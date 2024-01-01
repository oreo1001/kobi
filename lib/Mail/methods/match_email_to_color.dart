import 'package:flutter/material.dart';

Color matchEmailToColor(String email) {
  const List<Color> colors = [
    Color(0xffB1ECFF),
    Color(0xffFF7D61),
    Color(0xffFF82BE),
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.lightBlueAccent,
    Colors.indigo,
    Colors.purple,
  ];

  int index = email.hashCode % colors.length;
  return colors[index];
}