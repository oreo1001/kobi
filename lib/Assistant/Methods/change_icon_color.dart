import 'package:flutter/material.dart';

Icon changeIconColor(Icon originalIcon, Color newColor) {
  return Icon(
    originalIcon.icon,
    color: newColor,
    size: originalIcon.size,
    // 기타 다른 필요한 속성들도 이곳에 추가
  );
}
