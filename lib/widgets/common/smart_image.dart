import 'dart:io';
import 'package:flutter/material.dart';

class SmartImage extends StatelessWidget {
  final String? imagePath;
  final String placeholder;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SmartImage({
    super.key,
    this.imagePath,
    required this.placeholder,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  // Construye el widget de imagen correcto según el tipo de path
  Widget _buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return Image.asset(
        placeholder,
        fit: fit,
        // width/height infinity para que rellene el padre
        width: width ?? double.infinity,
        height: height,
      );
    }

    if (imagePath!.startsWith('http')) {
      return Image.network(
        imagePath!,
        fit: fit,
        width: width ?? double.infinity,
        height: height,
        errorBuilder: (_, _, _) => Image.asset(
          placeholder,
          fit: fit,
          width: width ?? double.infinity,
          height: height,
        ),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            width: width ?? double.infinity,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    // Ruta local
    final file = File(imagePath!);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: fit,
        width: width ?? double.infinity,
        height: height,
      );
    }

    // Si el archivo local no existe mostramos placeholder
    return Image.asset(
      placeholder,
      fit: fit,
      width: width ?? double.infinity,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _buildImage();

    // Si hay borderRadius la aplicamos con ClipRRect
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}