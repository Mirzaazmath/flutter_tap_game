

import 'package:flutter/material.dart';

// TARGET COLORS
const targetColors = [Colors.orange, Colors.green, Colors.yellow, Colors.blue,Colors.deepPurpleAccent];
const textColors = [Colors.deepPurpleAccent,Colors.blue,Colors.green, Colors.yellow, Colors.orange];


// TARGET ENUM
enum TargetType { color, number }


// TARGET MODEL CLASS
class TargetData {
  TargetData({required this.type, required this.index});
  final TargetType type;
  final int index;

  String get text =>

  '$index';
  Color get color => textColors[index];
}
