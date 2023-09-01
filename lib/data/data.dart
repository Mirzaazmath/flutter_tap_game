

import 'package:flutter/material.dart';

const targetColors = [Colors.orange, Colors.green, Colors.yellow, Colors.blue];
const textColors = [Colors.blue, Colors.yellow, Colors.green, Colors.orange];
const colorNames = ['orange', 'green', 'yellow', 'blue'];


enum TargetType { color, number }



class TargetData {
  TargetData({required this.type, required this.index});
  final TargetType type;
  final int index;

  String get text => type == TargetType.color
      ? 'COLOR ${colorNames[index]}'
      : 'NUMBER $index';
  Color get color => textColors[index];
}
