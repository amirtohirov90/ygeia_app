import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/feed_content.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: YgeiaColors.bgBase,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(painter: _LeafPainter()),
          ),
        ),
        title: Text(
          'ygeía',
          style: GoogleFonts.fraunces(
            color: YgeiaColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: const FeedContent(),
    );
  }
}

class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = YgeiaColors.accent
      ..style = PaintingStyle.fill;

    final leaf = Path();
    leaf.moveTo(w * 0.50, h * 0.98);
    leaf.cubicTo(
      w * -0.05, h * 0.75,
      w * -0.05, h * 0.20,
      w * 0.50, h * 0.02,
    );
    leaf.cubicTo(
      w * 1.05, h * 0.20,
      w * 1.05, h * 0.75,
      w * 0.50, h * 0.98,
    );
    leaf.close();
    canvas.drawPath(leaf, fillPaint);

    final veinPaint = Paint()
      ..color = YgeiaColors.bgBase.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;

    final vein = Path();
    vein.moveTo(w * 0.50, h * 0.95);
    vein.quadraticBezierTo(w * 0.50, h * 0.50, w * 0.50, h * 0.05);
    canvas.drawPath(vein, veinPaint);
  }

  @override
  bool shouldRepaint(_LeafPainter old) => false;
}
