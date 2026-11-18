import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../theme.dart';

/// A lightweight drawn map for the demo. In production this widget is
/// replaced by a real map package; the rest of the app does not change.
class CityMap extends StatelessWidget {
  const CityMap({super.key, required this.drivers, this.highlight, this.showPickup = true});

  final List<Driver> drivers;
  final Driver? highlight;
  final bool showPickup;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final size = Size(box.maxWidth, box.maxHeight);
        return Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _StreetsPainter())),
            if (showPickup)
              Positioned(
                left: size.width * .5 - 14,
                top: size.height * .5 - 34,
                child: const Icon(Icons.location_on, size: 34, color: haloInk),
              ),
            for (final d in drivers)
              AnimatedPositioned(
                key: ValueKey(d.id),
                duration: const Duration(milliseconds: 1800),
                curve: Curves.easeInOut,
                left: size.width * d.position.dx - 16,
                top: size.height * d.position.dy - 16,
                child: _CarMarker(selected: d.id == highlight?.id),
              ),
          ],
        );
      },
    );
  }
}

class _CarMarker extends StatelessWidget {
  const _CarMarker({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: selected ? haloInk : haloYellow,
        shape: BoxShape.circle,
        border: Border.all(color: haloInk, width: 2),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Color(0x33000000), offset: Offset(0, 2))],
      ),
      child: Icon(Icons.local_taxi, size: 18, color: selected ? haloYellow : haloInk),
    );
  }
}

class _StreetsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEDEAE0));

    final park = Paint()..color = const Color(0xFFCFE3C4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * .08, size.height * .1, size.width * .22, size.height * .18), const Radius.circular(10)),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * .66, size.height * .7, size.width * .26, size.height * .2), const Radius.circular(10)),
      park,
    );

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    for (final x in [.18, .42, .66, .88]) {
      canvas.drawLine(Offset(size.width * x, 0), Offset(size.width * x, size.height), road);
    }
    for (final y in [.2, .5, .8]) {
      canvas.drawLine(Offset(0, size.height * y), Offset(size.width, size.height * y), road);
    }
    canvas.drawLine(Offset(0, size.height * .95), Offset(size.width, size.height * .35), road..strokeWidth = 14);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
