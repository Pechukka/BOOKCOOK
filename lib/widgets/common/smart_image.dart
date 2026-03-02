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

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (imagePath == null || imagePath!.isEmpty) {
      image = Image.asset(placeholder, fit: fit);

    } else if (imagePath!.startsWith('http')) {
      image = Image.network(
        imagePath!,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            Image.asset(placeholder, fit: fit),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );

    } else {
      final file = File(imagePath!);
      image = file.existsSync()
          ? Image.file(file, fit: fit)
          : Image.asset(placeholder, fit: fit);
    }

    Widget result = SizedBox(
      height: height,
      width: width,
      child: image,
    );

    if (borderRadius != null) {
      result = ClipRRect(borderRadius: borderRadius!, child: result);
    }

    return result;
  }
}