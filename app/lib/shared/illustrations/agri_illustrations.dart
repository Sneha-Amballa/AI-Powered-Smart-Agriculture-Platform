import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum AgriIllustrationType {
  crop,
  disease,
  pest,
  weather,
  market,
  schemes,
  assistant,
  soil,
  farm,
}

/// Native vector illustrations for precision agriculture modules.
/// Scale-independent, lightweight, offline-ready, and high contrast.
class AgriIllustration extends StatelessWidget {
  final AgriIllustrationType type;
  final double size;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AgriIllustration({
    super.key,
    required this.type,
    this.size = 56.0,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AgriIllustrationPainter(
          type: type,
          primaryColor: primaryColor ?? AppColors.primary,
          secondaryColor: secondaryColor ?? AppColors.sage,
        ),
      ),
    );
  }
}

class _AgriIllustrationPainter extends CustomPainter {
  final AgriIllustrationType type;
  final Color primaryColor;
  final Color secondaryColor;

  _AgriIllustrationPainter({
    required this.type,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Background circle badge
    final bgPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, w * 0.46, bgPaint);

    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = (w * 0.05).clamp(2.0, 4.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    switch (type) {
      case AgriIllustrationType.crop:
        _drawCrop(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.disease:
        _drawDisease(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.pest:
        _drawPest(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.weather:
        _drawWeather(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.market:
        _drawMarket(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.schemes:
        _drawSchemes(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.assistant:
        _drawAssistant(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.soil:
        _drawSoil(canvas, size, linePaint, fillPaint);
        break;
      case AgriIllustrationType.farm:
        _drawFarm(canvas, size, linePaint, fillPaint);
        break;
    }
  }

  void _drawCrop(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Soil line
    canvas.drawLine(Offset(w * 0.22, h * 0.74), Offset(w * 0.78, h * 0.74), stroke);

    // Stem
    final stem = Path()
      ..moveTo(w * 0.5, h * 0.74)
      ..quadraticBezierTo(w * 0.5, h * 0.48, w * 0.5, h * 0.32);
    canvas.drawPath(stem, stroke);

    // Left Leaf
    final leftLeaf = Path()
      ..moveTo(w * 0.5, h * 0.52)
      ..quadraticBezierTo(w * 0.28, h * 0.45, w * 0.28, h * 0.35)
      ..quadraticBezierTo(w * 0.42, h * 0.35, w * 0.5, h * 0.48);
    canvas.drawPath(leftLeaf, stroke);

    // Right Leaf
    final rightLeaf = Path()
      ..moveTo(w * 0.5, h * 0.44)
      ..quadraticBezierTo(w * 0.72, h * 0.37, w * 0.72, h * 0.27)
      ..quadraticBezierTo(w * 0.58, h * 0.27, w * 0.5, h * 0.40);
    canvas.drawPath(rightLeaf, stroke);

    // Sun ray accent dot
    canvas.drawCircle(Offset(w * 0.72, h * 0.22), w * 0.05, fill);
  }

  void _drawDisease(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Leaf outline
    final leaf = Path()
      ..moveTo(w * 0.5, h * 0.2)
      ..cubicTo(w * 0.8, h * 0.25, w * 0.75, h * 0.7, w * 0.5, h * 0.8)
      ..cubicTo(w * 0.25, h * 0.7, w * 0.2, h * 0.25, w * 0.5, h * 0.2);
    canvas.drawPath(leaf, stroke);

    // Leaf center vein
    canvas.drawLine(Offset(w * 0.5, h * 0.25), Offset(w * 0.5, h * 0.75), stroke);

    // Crosshair scan lens
    final lensCenter = Offset(w * 0.62, h * 0.42);
    final lensPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(lensCenter, w * 0.16, lensPaint);
    canvas.drawLine(
      Offset(lensCenter.dx - w * 0.09, lensCenter.dy),
      Offset(lensCenter.dx + w * 0.09, lensCenter.dy),
      lensPaint,
    );
    canvas.drawLine(
      Offset(lensCenter.dx, lensCenter.dy - w * 0.09),
      Offset(lensCenter.dx, lensCenter.dy + w * 0.09),
      lensPaint,
    );
  }

  void _drawPest(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Protective shield
    final shield = Path()
      ..moveTo(w * 0.5, h * 0.2)
      ..lineTo(w * 0.75, h * 0.3)
      ..lineTo(w * 0.75, h * 0.55)
      ..quadraticBezierTo(w * 0.5, h * 0.8, w * 0.5, h * 0.82)
      ..quadraticBezierTo(w * 0.5, h * 0.8, w * 0.25, h * 0.55)
      ..lineTo(w * 0.25, h * 0.3)
      ..close();
    canvas.drawPath(shield, stroke);

    // Bug body inside shield
    canvas.drawCircle(Offset(w * 0.5, h * 0.44), w * 0.07, fill);
    final bugBody = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.57), width: w * 0.18, height: h * 0.20),
      const Radius.circular(8),
    );
    canvas.drawRRect(bugBody, stroke);
    // Antennae
    canvas.drawLine(Offset(w * 0.46, h * 0.40), Offset(w * 0.40, h * 0.34), stroke);
    canvas.drawLine(Offset(w * 0.54, h * 0.40), Offset(w * 0.60, h * 0.34), stroke);
  }

  void _drawWeather(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Sun behind cloud
    canvas.drawCircle(Offset(w * 0.65, h * 0.36), w * 0.14, stroke);

    // Cloud
    final cloud = Path()
      ..moveTo(w * 0.32, h * 0.62)
      ..quadraticBezierTo(w * 0.22, h * 0.62, w * 0.22, h * 0.52)
      ..quadraticBezierTo(w * 0.22, h * 0.42, w * 0.35, h * 0.42)
      ..quadraticBezierTo(w * 0.42, h * 0.34, w * 0.54, h * 0.36)
      ..quadraticBezierTo(w * 0.66, h * 0.38, w * 0.68, h * 0.48)
      ..quadraticBezierTo(w * 0.78, h * 0.50, w * 0.76, h * 0.62)
      ..close();
    canvas.drawPath(cloud, stroke);

    // Raindrops
    canvas.drawLine(Offset(w * 0.36, h * 0.70), Offset(w * 0.32, h * 0.78), stroke);
    canvas.drawLine(Offset(w * 0.52, h * 0.70), Offset(w * 0.48, h * 0.78), stroke);
    canvas.drawLine(Offset(w * 0.68, h * 0.70), Offset(w * 0.64, h * 0.78), stroke);
  }

  void _drawMarket(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Chart axes
    canvas.drawLine(Offset(w * 0.24, h * 0.74), Offset(w * 0.78, h * 0.74), stroke);
    canvas.drawLine(Offset(w * 0.24, h * 0.74), Offset(w * 0.24, h * 0.26), stroke);

    // Upward trend line
    final trend = Path()
      ..moveTo(w * 0.30, h * 0.64)
      ..lineTo(w * 0.44, h * 0.52)
      ..lineTo(w * 0.58, h * 0.58)
      ..lineTo(w * 0.74, h * 0.34);
    canvas.drawPath(trend, stroke);

    // Arrowhead
    final arrow = Path()
      ..moveTo(w * 0.64, h * 0.34)
      ..lineTo(w * 0.74, h * 0.34)
      ..lineTo(w * 0.74, h * 0.44);
    canvas.drawPath(arrow, stroke);

    // Coin badge
    canvas.drawCircle(Offset(w * 0.42, h * 0.36), w * 0.08, fill);
  }

  void _drawSchemes(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Official Building roof triangle
    final roof = Path()
      ..moveTo(w * 0.5, h * 0.24)
      ..lineTo(w * 0.76, h * 0.40)
      ..lineTo(w * 0.24, h * 0.40)
      ..close();
    canvas.drawPath(roof, stroke);

    // Pillars
    canvas.drawLine(Offset(w * 0.34, h * 0.42), Offset(w * 0.34, h * 0.66), stroke);
    canvas.drawLine(Offset(w * 0.50, h * 0.42), Offset(w * 0.50, h * 0.66), stroke);
    canvas.drawLine(Offset(w * 0.66, h * 0.42), Offset(w * 0.66, h * 0.66), stroke);

    // Base
    canvas.drawLine(Offset(w * 0.24, h * 0.68), Offset(w * 0.76, h * 0.68), stroke);
    canvas.drawLine(Offset(w * 0.20, h * 0.74), Offset(w * 0.80, h * 0.74), stroke);
  }

  void _drawAssistant(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Chat bubble
    final bubble = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.46), width: w * 0.52, height: h * 0.38),
      const Radius.circular(10),
    );
    canvas.drawRRect(bubble, stroke);

    // Tail
    final tail = Path()
      ..moveTo(w * 0.42, h * 0.65)
      ..lineTo(w * 0.34, h * 0.76)
      ..lineTo(w * 0.52, h * 0.65)
      ..close();
    canvas.drawPath(tail, fill);

    // Sound / spark waves inside
    canvas.drawLine(Offset(w * 0.36, h * 0.46), Offset(w * 0.36, h * 0.46), stroke);
    canvas.drawLine(Offset(w * 0.46, h * 0.40), Offset(w * 0.46, h * 0.52), stroke);
    canvas.drawLine(Offset(w * 0.56, h * 0.36), Offset(w * 0.56, h * 0.56), stroke);
    canvas.drawLine(Offset(w * 0.64, h * 0.46), Offset(w * 0.64, h * 0.46), stroke);
  }

  void _drawSoil(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Flask body
    final flask = Path()
      ..moveTo(w * 0.44, h * 0.24)
      ..lineTo(w * 0.56, h * 0.24)
      ..lineTo(w * 0.56, h * 0.42)
      ..lineTo(w * 0.74, h * 0.72)
      ..quadraticBezierTo(w * 0.74, h * 0.78, w * 0.68, h * 0.78)
      ..lineTo(w * 0.32, h * 0.78)
      ..quadraticBezierTo(w * 0.26, h * 0.78, w * 0.26, h * 0.72)
      ..lineTo(w * 0.44, h * 0.42)
      ..close();
    canvas.drawPath(flask, stroke);

    // Liquid fill level
    final liquid = Path()
      ..moveTo(w * 0.34, h * 0.60)
      ..lineTo(w * 0.66, h * 0.60)
      ..lineTo(w * 0.72, h * 0.72)
      ..lineTo(w * 0.28, h * 0.72)
      ..close();
    canvas.drawPath(liquid, stroke);

    // Nutrient nutrient bubble dots
    canvas.drawCircle(Offset(w * 0.42, h * 0.68), w * 0.04, fill);
    canvas.drawCircle(Offset(w * 0.56, h * 0.66), w * 0.03, fill);
    canvas.drawCircle(Offset(w * 0.50, h * 0.48), w * 0.035, fill);
  }

  void _drawFarm(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Sun
    canvas.drawCircle(Offset(w * 0.72, h * 0.30), w * 0.12, stroke);

    // Furrow hills
    final hill1 = Path()
      ..moveTo(w * 0.18, h * 0.76)
      ..quadraticBezierTo(w * 0.40, h * 0.54, w * 0.62, h * 0.76);
    canvas.drawPath(hill1, stroke);

    final hill2 = Path()
      ..moveTo(w * 0.45, h * 0.76)
      ..quadraticBezierTo(w * 0.68, h * 0.58, w * 0.82, h * 0.76);
    canvas.drawPath(hill2, stroke);

    // Base soil line
    canvas.drawLine(Offset(w * 0.16, h * 0.76), Offset(w * 0.84, h * 0.76), stroke);
  }

  @override
  bool shouldRepaint(covariant _AgriIllustrationPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
