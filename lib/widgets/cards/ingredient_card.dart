import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {

  final String name;
  final String? brand;
  final String? imagePath;
  
  final VoidCallback onTap;

  const IngredientCard({
    super.key,
    required this.name,
    required this.onTap,
    this.brand,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // IMAGEN
              Expanded(
                flex: 3,
                child: _buildImage(),
              ),

              // TEXTOS
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    // start → alineados a la izquierda
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // center → centrados verticalmente en el espacio disponible
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // NOMBRE DEL INGREDIENTE
                      Text(
                        name,
                        style: Theme.of(context).textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                      // MARCA
                      if (brand != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          brand!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // METODO PARA DECIDIR CARGAR IMAGEN
  Widget _buildImage() {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      'assets/images/placeholder_ingredient.png',
      fit: BoxFit.cover,
    );
  }
}