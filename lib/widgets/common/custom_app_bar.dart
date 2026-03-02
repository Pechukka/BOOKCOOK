import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      centerTitle: true,

      // ── FLECHA DE VOLVER ──
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null, // null → si el booleano es false no se muestra la flecha

      // ── TÍTULO ──
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}