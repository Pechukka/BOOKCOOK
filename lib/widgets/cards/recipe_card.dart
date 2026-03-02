// lib/widgets/cards/recipe_card.dart

import 'package:flutter/material.dart';


class RecipeCard extends StatelessWidget {
  final String name;
  final String? imagePath; // nullable: puede no tener imagen
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.name,
    required this.onTap,
    this.imagePath, // opcional sin required
  });

  @override
  Widget build(BuildContext context) {

    // InkWell hace que cualquier widget reaccione al tap con el efecto de onda 
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

        // ClipRRect recorta sus hijos con bordes redondeados.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // IMAGEN 
              Expanded(
                flex: 2,
                child: _buildImage(),
              ),

              // NOMBRE
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.labelMedium,
                    // Si el nombre es muy largo, corta con "..."
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
      'assets/images/placeholder_recipe.png',
      fit: BoxFit.cover,
    );
  }
}