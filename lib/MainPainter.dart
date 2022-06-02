import 'dart:math' show pi;
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final double end;
  final int minutes;
  final int seconds;

  const MyPainter( {
    required this.end,
    required this.minutes,
    required this.seconds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    mainBack(canvas, size);
    mainCircle(canvas, size, end);
    drawText(canvas, size, minutes, seconds);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.end != end ||
        oldDelegate.seconds != seconds ||
        oldDelegate.minutes != minutes;
  }
}

void mainCircle(Canvas canvas, Size size, double end) {
  const double strokeWidth = 50;
  final Paint paint = Paint()
    ..color = Colors.lightBlueAccent
  // ..shader = const SweepGradient(
  //     startAngle: 1,
  //     endAngle: pi * 2,
  //     transform: GradientRotation(-pi / 2),
  //     colors: [
  //       Colors.lightBlueAccent,
  //       Colors.lightBlue,
  //       Colors.lightBlue,
  //       Color(0xffd00000),
  //       Color(0xff9d0208),
  //     ]).createShader(const Offset(strokeWidth / 2, strokeWidth / 2) &
  //     Size(size.width - strokeWidth, size.height - strokeWidth))
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round;

  canvas.drawArc(
      const Offset(strokeWidth / 2, strokeWidth / 2) &
      Size(size.width - strokeWidth, size.height - strokeWidth),
      -pi / 2,
      end,
      false,
      paint);
}

void mainBack(Canvas canvas, Size size) {
  const double strokeWidth = 50;
  final Paint paint = Paint()
    ..color = Colors.teal.withOpacity(0.1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth;

  canvas.drawArc(
      const Offset(strokeWidth / 2, strokeWidth / 2) &
      Size(size.width - strokeWidth, size.height - strokeWidth),
      -pi / 2,
      pi * 2,
      false,
      paint);
}

void drawText(Canvas canvas, Size size, int minutes, int seconds) {
  String strSec = seconds < 10 ? '0$seconds' : '$seconds';
  String strMin = minutes < 10 ? '0$minutes' : '$minutes';

  TextSpan text = TextSpan(
      text: '$strMin:$strSec',
      style: const TextStyle(color: Colors.black, fontSize: 50));
  TextPainter textPainter = TextPainter(
      text: text,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr);
  textPainter.layout();
  /* Все эти вычисления работают только после textPainter.layout(),
  т.к этот метод расчитывает высоту и ширину текста */
  double textWidthCenter = textPainter.width / 2;
  double textHeightCenter = textPainter.height / 2;
  double sizeWidthCenter = size.width / 2;
  double sizeHeightCenter = size.height / 2;
  Offset offsetCenter = Offset(
      sizeWidthCenter - textWidthCenter, sizeHeightCenter - textHeightCenter);
  textPainter.paint(canvas, offsetCenter);
}

