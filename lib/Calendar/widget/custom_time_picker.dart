import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class CustomPicker extends picker.CommonPickerModel {
  String? digits(int value, int length) {
    return value.toString();
  }

  CustomPicker({DateTime? currentTime, picker.LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour >= 12 ? 1 : 0);
    this.setMiddleIndex(
        this.currentTime.hour % 12 == 0 ? 12 : this.currentTime.hour % 12);
    this.setRightIndex(this.currentTime.minute == 0
        ? 12
        : (this.currentTime.minute / 5).round());
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index == 0) {
      return 'AM';
    } else if (index == 1) {
      return 'PM';
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    int hour = index % 12 == 0 ? 12 : index % 12;
    return this.digits(hour, 2);
  }

  @override
  String? rightStringAtIndex(int index) {
    int minute = (index * 5) % 60;
    return this.digits(minute, 2);
  }

  @override
  String leftDivider() {
    return " ";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }

  @override
  DateTime finalTime() {
    int hour = this.currentMiddleIndex() % 12;
    int minute = this.currentRightIndex() == 12 ? 0 : this.currentRightIndex() * 5;

    if (this.currentLeftIndex() == 1) {
      hour += 12;
    }

    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        hour,
        minute)
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        hour,
        minute);
  }
}
