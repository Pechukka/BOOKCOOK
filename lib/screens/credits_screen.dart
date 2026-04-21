import 'package:flutter/material.dart';
import '../widgets/common/custom_app_bar.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Credits'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // LOGO
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_white.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NOMBRE DE LA APP
            Center(
              child: Text(
                'BookCook',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                ),
              ),
            ),

            Center(
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 40),

            // AUTOR
            _CreditsSection(
              icon: Icons.person_outline_rounded,
              title: 'Author',
              content: 'Elias Pedrosa Madrid\nDAM — 2025/2026',
            ),

            const SizedBox(height: 20),

            // DESCRIPCIÓN
            _CreditsSection(
              icon: Icons.info_outline_rounded,
              title: 'About',
              content:
                  'BookCook is a personal recipe manager that lets you '
                  'scan food products, track nutritional information '
                  'and organize your favorite recipes.',
            ),

            const SizedBox(height: 20),

            // TECNOLOGÍAS
            _CreditsSection(
              icon: Icons.code_rounded,
              title: 'Built with',
              content:
                  'Flutter · Firebase Auth · Cloud Firestore\n'
                  'Open Food Facts API · mobile_scanner',
            ),

            const SizedBox(height: 20),

            // AGRADECIMIENTOS
            _CreditsSection(
              icon: Icons.favorite_outline_rounded,
              title: 'Data provided by',
              content:
                  'Open Food Facts — openfoodfacts.org\n'
                  'Free and open food products database',
            ),

            const SizedBox(height: 40),

            // AÑO
            Center(
              child: Text(
                '© 2026 BookCook',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


// ── SECCIÓN DE CRÉDITOS ──
class _CreditsSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _CreditsSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}