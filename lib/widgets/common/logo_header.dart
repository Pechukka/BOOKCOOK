// lib/widgets/common/logo_header.dart

import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final String subtitle;

  const LogoHeader({
    super.key,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        // LOGO
        Image.asset(
          'assets/images/logo_brown.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 16),

        // TÍTULO
        Text(
          'BookCook',
          style: Theme.of(context).textTheme.headlineLarge,
        ),

        const SizedBox(height: 8),

        // SUBTÍTULO
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}