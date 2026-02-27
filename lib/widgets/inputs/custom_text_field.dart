import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String label;                     // "Email", "Password", "Name"...
  final String hint;                      // texto gris dentro del campo
  final IconData prefixIcon;              // icono a la izquierda
  final TextEditingController controller; // controlador
  final bool isPassword;                  // boolean para ocultar contenido o no
  final TextInputType keyboardType;       // tipo de teclado (numerico, texto, con @...)

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,

    // opcionales
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // LABEL
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),

        const SizedBox(height: 8),

        // CAMPO DE TEXTO
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon),
          ),
        ),
      ],
    );
  }
}