import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'gate_pass_controller.dart';
import 'bale_qr_detail_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _scannerCtrl = MobileScannerController();
  bool _scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue ?? '';

    if (rawValue.startsWith('BALE:')) {
      _scanned = true;
      _scannerCtrl.stop();

      // Parse: BALE:id|baleNumber|itemType|quantity|location|status
      final data = rawValue.replaceFirst('BALE:', '');
      final parts = data.split('|');
      final baleId = parts.isNotEmpty ? parts[0] : '';

      Get.off(() => BaleQrDetailScreen(baleId: baleId));
    } else {
      Get.snackbar('Invalid QR', 'This QR code is not a valid TexOps bale.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF85149),
          colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    _scannerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Scan Bale QR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Color(0xFF58A6FF)),
            onPressed: () => _scannerCtrl.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Color(0xFF58A6FF)),
            onPressed: () => _scannerCtrl.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerCtrl,
            onDetect: _onDetect,
          ),
          // Overlay
          CustomPaint(
            painter: _ScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),
          // Bottom hint
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Point camera at a TexOps Bale QR Code',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const scanSize = 260.0;
    final left = (size.width - scanSize) / 2;
    final top = (size.height - scanSize) / 2;
    final rect = Rect.fromLTWH(left, top, scanSize, scanSize);

    // Dim background
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16))),
      ),
      paint,
    );

    // Corner brackets
    final bracketPaint = Paint()
      ..color = const Color(0xFF58A6FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const corner = 30.0;
    // TL
    canvas.drawLine(Offset(left, top + corner), Offset(left, top), bracketPaint);
    canvas.drawLine(Offset(left, top), Offset(left + corner, top), bracketPaint);
    // TR
    canvas.drawLine(Offset(left + scanSize - corner, top),
        Offset(left + scanSize, top), bracketPaint);
    canvas.drawLine(Offset(left + scanSize, top),
        Offset(left + scanSize, top + corner), bracketPaint);
    // BL
    canvas.drawLine(Offset(left, top + scanSize - corner),
        Offset(left, top + scanSize), bracketPaint);
    canvas.drawLine(Offset(left, top + scanSize),
        Offset(left + corner, top + scanSize), bracketPaint);
    // BR
    canvas.drawLine(Offset(left + scanSize - corner, top + scanSize),
        Offset(left + scanSize, top + scanSize), bracketPaint);
    canvas.drawLine(Offset(left + scanSize, top + scanSize - corner),
        Offset(left + scanSize, top + scanSize), bracketPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
