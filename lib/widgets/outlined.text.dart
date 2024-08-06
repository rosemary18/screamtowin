import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color outlineColor;
  final Color textColor;

  const OutlinedText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.outlineColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: "akagipro-fat",
            fontWeight: FontWeight.bold,
            height: 1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 5
              ..color = outlineColor
              ..strokeJoin = StrokeJoin.round,
            letterSpacing: -1,
            shadows: const [
              Shadow(
                blurRadius: 1,
                color: Color(0xFF116B35),
                offset: Offset(4.0, 5.0),
              ),
            ],
          ),
        ),
        // Solid text
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              height: 1,
              letterSpacing: -1,
              fontFamily: "akagipro-fat",
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
