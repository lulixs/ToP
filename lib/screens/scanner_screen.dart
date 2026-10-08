import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'box_page_screen.dart';

/// 05a/b/c: QR scanner placeholder. No camera yet; demo buttons fake a scan.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

enum _Result { none, noMatch, deleted }

class _ScannerScreenState extends State<ScannerScreen> {
  _Result result = _Result.none;

  void _openBox(int id) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BoxPageScreen(boxId: id)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Striped background stands in for the live camera image.
        Positioned.fill(child: CustomPaint(painter: _StripePainter())),
        // Viewfinder. Tapping it fakes a successful scan.
        Center(
          child: GestureDetector(
            onTap: () => _openBox(6789),
            child: SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: _ViewfinderPainter(),
                child: Align(
                  alignment: Alignment(0, 1.35),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xE6FFFFFF), borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text('Placeholder: live camera image',
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF555555))),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Top bar
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            color: Color(0xD1222222),
            padding: EdgeInsets.fromLTRB(22, MediaQuery.paddingOf(context).top + 20, 22, 20),
            child: Row(children: [
              BackCircle(onTap: () => Navigator.pop(context), color: Colors.white),
              SizedBox(width: 16),
              Text('Scan a box', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
        // Bottom: instructions or result sheet
        Positioned(left: 0, right: 0, bottom: 0, child: result == _Result.none ? _instructions() : _sheet()),
      ]),
    );
  }

  Widget _instructions() {
    return Container(
      color: Color(0xD1222222),
      padding: EdgeInsets.fromLTRB(26, 22, 26, 26),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Point the camera at a box label',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          SizedBox(height: 6),
          Text('The box page opens as soon as the code is read',
              style: TextStyle(color: Color(0xFFE2E2E2), fontSize: 14)),
          SizedBox(height: 16),
          Text('Demo (no camera yet):', style: TextStyle(color: Color(0xFFE2E2E2), fontSize: 12)),
          SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
            PillButton('Scan Box #6789', small: true, onTap: () => _openBox(6789)),
            PillButton('Scan Box #6744 (unracked)', small: true, onTap: () => _openBox(6744)),
            PillButton('Unknown code', small: true, onTap: () => setState(() => result = _Result.noMatch)),
            PillButton('Deleted box', small: true, onTap: () => setState(() => result = _Result.deleted)),
          ]),
        ]),
      ),
    );
  }

  Widget _sheet() {
    final info = deletedInfo[6602]!;
    final (title, msg) = result == _Result.noMatch
        ? (
            'No box matches this code',
            'This QR code is not an IMP box label, or the box was permanently deleted. Check the label and try again.'
          )
        : (
            'Box #6602 was deleted',
            '${info[1]} deleted this box on ${info[0]}. It is hidden until the Master account restores it from Deleted Items.'
          );
    return Container(
      padding: EdgeInsets.fromLTRB(30, 24, 30, 26),
      decoration: BoxDecoration(
        color: C.card,
        border: Border(top: BorderSide(color: C.ink, width: 2)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Icon(Icons.error_outline, size: 26),
            SizedBox(width: 10),
            Expanded(child: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
          ]),
          SizedBox(height: 10),
          Text(msg, style: TextStyle(fontSize: 14.5, height: 1.5)),
          SizedBox(height: 16),
          Row(children: [
            PillButton('Back', onTap: () => Navigator.pop(context)),
            SizedBox(width: 10),
            PillButton('Scan again', style: BtnStyle.primary, onTap: () => setState(() => result = _Result.none)),
          ]),
        ]),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final p = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..strokeWidth = 18;
    for (double x = -size.height; x < size.width; x += 51) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = Color(0xFF222222)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const l = 60.0;
    canvas.drawPath(Path()..moveTo(0, l)..lineTo(0, 0)..lineTo(l, 0), p);
    canvas.drawPath(Path()..moveTo(s.width - l, 0)..lineTo(s.width, 0)..lineTo(s.width, l), p);
    canvas.drawPath(Path()..moveTo(0, s.height - l)..lineTo(0, s.height)..lineTo(l, s.height), p);
    canvas.drawPath(
        Path()..moveTo(s.width - l, s.height)..lineTo(s.width, s.height)..lineTo(s.width, s.height - l), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
