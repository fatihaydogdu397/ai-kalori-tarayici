import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/food_api_service.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';
import 'result_screen.dart';
import 'package:provider/provider.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final _controller = MobileScannerController();
  final _api = FoodApiService();
  bool _scanning = true;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_scanning || _loading) return;
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;

    setState(() { _scanning = false; _loading = true; });
    await _controller.stop();

    final l = AppLocalizations.of(context);
    final analysis = await _api.fetchByBarcode(barcode);

    if (!mounted) return;

    if (analysis == null) {
      setState(() { _loading = false; _scanning = true; });
      _controller.start();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.barcodeNotFound),
          backgroundColor: AppColors.coral,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // DB'ye kaydet
    await context.read<AppProvider>().saveManualEntry(analysis);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(analysis: analysis)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Kamera
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay
          _ScanOverlay(accent: accent),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _controller.toggleTorch(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Alt bilgi
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  if (_loading)
                    Column(children: [
                      CircularProgressIndicator(color: accent, strokeWidth: 2),
                      const SizedBox(height: 12),
                      Text(l.barcodeSearching, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ])
                  else
                    Text(
                      l.barcodeHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tarama çerçevesi
class _ScanOverlay extends StatelessWidget {
  final Color accent;
  const _ScanOverlay({required this.accent});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const boxSize = 260.0;
    final top = (size.height - boxSize) / 2 - 40;

    return Stack(
      children: [
        // Karartma
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.55), BlendMode.srcOut),
          child: Stack(
            children: [
              Container(color: Colors.transparent),
              Positioned(
                left: (size.width - boxSize) / 2,
                top: top,
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Köşe çizgileri
        Positioned(
          left: (size.width - boxSize) / 2,
          top: top,
          child: _CornerFrame(size: boxSize, color: accent),
        ),
      ],
    );
  }
}

class _CornerFrame extends StatelessWidget {
  final double size;
  final Color color;
  const _CornerFrame({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    const w = 3.0;
    const len = 24.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Sol üst
          Positioned(top: 0, left: 0, child: _L(color: color, w: w, len: len)),
          // Sağ üst
          Positioned(top: 0, right: 0, child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14159),
            child: _L(color: color, w: w, len: len),
          )),
          // Sol alt
          Positioned(bottom: 0, left: 0, child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(3.14159),
            child: _L(color: color, w: w, len: len),
          )),
          // Sağ alt
          Positioned(bottom: 0, right: 0, child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(3.14159),
            child: _L(color: color, w: w, len: len),
          )),
        ],
      ),
    );
  }
}

class _L extends StatelessWidget {
  final Color color;
  final double w, len;
  const _L({required this.color, required this.w, required this.len});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: len, height: len,
      child: Stack(children: [
        Positioned(top: 0, left: 0, child: Container(width: len, height: w, color: color)),
        Positioned(top: 0, left: 0, child: Container(width: w, height: len, color: color)),
      ]),
    );
  }
}
