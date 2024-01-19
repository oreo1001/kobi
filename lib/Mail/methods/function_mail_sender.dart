import 'dart:math';
import 'package:flutter/material.dart';

List<TextSpan> highlightOccurrences(String source, String query) {
  if (query == null || query.isEmpty) {
    return [TextSpan(text: limitText(source, 30))];
  }
  var spans = <TextSpan>[];
  int start = 0;
  int indexOfHighlight = source.toLowerCase().indexOf(query.toLowerCase());
  while (indexOfHighlight != -1) {
    spans.add(TextSpan(text: source.substring(start, indexOfHighlight)));
    spans.add(TextSpan(
        text: limitText(
            source.substring(indexOfHighlight, indexOfHighlight + query.length),
            25),
        style: TextStyle(color: Colors.blue)));
    start = indexOfHighlight + query.length;
    indexOfHighlight = source.toLowerCase().indexOf(query.toLowerCase(), start);
  }
  spans.add(TextSpan(text: limitText(source.substring(start), 30)));
  return spans;
}

String limitText(String text, int limit) {
  return (text.length <= limit) ? text : '${text.substring(0, limit)}...';
}

String generateRandomId(int length) {
  final Random random = Random();
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  return List.generate(
      length, (index) => chars[random.nextInt(chars.length)]).join();
}