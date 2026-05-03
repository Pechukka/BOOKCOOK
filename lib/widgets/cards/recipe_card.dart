import 'dart:io';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String name;
  final String? imagePath;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.name,
    this.imagePath,
    this.onTap,
  });

  ImageProvider _resolveImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return const AssetImage('assets/images/placeholder_recipe.png');
    }
    if (imagePath!.startsWith('http')) {
      return NetworkImage(imagePath!);
    }
    return FileImage(File(imagePath!));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image(
                  image: _resolveImage(),
                  fit: BoxFit.cover,
                  alignment: (imagePath == null || imagePath!.isEmpty)
                      ? Alignment.centerLeft
                      : Alignment.center,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}