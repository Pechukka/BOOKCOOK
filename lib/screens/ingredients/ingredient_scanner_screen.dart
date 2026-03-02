import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../widgets/common/custom_app_bar.dart';

class IngredientScannerScreen extends StatelessWidget {
  const IngredientScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'BookCook'),

      body: Stack(
        children: [

          // ── FONDO SIMULANDO CAMARA POR AHORA ───
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
          ),

          // ── MARCO DE ESCANEO ──
          Center(
            child: _ScannerFrame(),
          ),

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

          // ── BOTÓN INFERIOR ──
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: _ScanButton(
              onPressed: () {
                // FASE 1: navegamos directamente a la confirmación
                // simulando que se ha escaneado un producto.
                // FASE 5: aquí el escáner real devolverá el código
                // de barras y haremos la llamada a la API.
                Navigator.pushNamed(context, AppRoutes.ingredientConfirm);
              },
            ),
          ),
        ],
      ),
    );
  }
}


// ── MARCO DEL ESCÁNER ──
class _ScannerFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        // Sin color de fondo — queremos ver a través del marco
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
      ),
    );
  }
}


// ── BOTÓN DE ESCANEO ──
class _ScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ScanButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text(
        'Scanning automatically',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}