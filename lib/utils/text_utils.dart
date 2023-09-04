import 'package:flutter/material.dart';
// CUSTOM CLASS FOR TEXT DESIGN
class TextPrompt extends StatelessWidget {
  const TextPrompt(
      this.text, {
        Key? key,
        required this.color,
        this.fontSize = 32,
      }) : super(key: key);
  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      child: Text(text),
      duration: Duration(milliseconds: 250),
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
    );
  }
}