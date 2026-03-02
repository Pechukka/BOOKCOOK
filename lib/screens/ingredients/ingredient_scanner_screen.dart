import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../app/routes.dart';
import '../../services/open_food_service.dart';
import '../../widgets/common/custom_app_bar.dart';

class IngredientScannerScreen extends StatefulWidget {
  const IngredientScannerScreen({super.key});

  @override
  State<IngredientScannerScreen> createState() =>
      _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen> {

  final MobileScannerController _cameraController = MobileScannerController();

  bool _isProcessing = false;
  bool _isLoading = false;    

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    final code = barcode!.rawValue!;

    _cameraController.stop();

    setState(() {
      _isProcessing = true;
      _isLoading = true;
    });

    final result = await OpenFoodService.instance.getByBarcode(code);

    if (!mounted) return;

    setState(() => _isLoading = false);

    await Navigator.pushNamed(
      context,
      AppRoutes.ingredientConfirm,
      arguments: result,
    );

    if (mounted) {
      setState(() => _isProcessing = false);
      _cameraController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'BookCook'),
      body: Stack(
        children: [

          // ── CÁMARA REAL ──
          MobileScanner(
            controller: _cameraController,
            onDetect: _onBarcodeDetected,
          ),

          // ── MARCO DE ESCANEO ──
          Center(child: _ScannerFrame()),

          // ── TEXTO DE INSTRUCCIÓN ──
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Text(
              'Align the barcode inside the frame',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),

          // ── SPINNER DE CARGA ─
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Searching product...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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


class _ScannerFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
      ),
    );
  }
}