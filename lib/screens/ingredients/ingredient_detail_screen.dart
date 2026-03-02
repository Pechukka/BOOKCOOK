import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../models/ingredient.dart';
import '../../services/ingredient_service.dart';
import '../../widgets/common/custom_app_bar.dart';

class IngredientDetailScreen extends StatelessWidget {
  const IngredientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ingredient =
        ModalRoute.of(context)!.settings.arguments as Ingredient;

    return Scaffold(
      appBar: const CustomAppBar(title: 'BookCook'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            _IngredientDetailImage(imagePath: ingredient.imagePath),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _IngredientDetailHeader(
                    name: ingredient.name,
                    brand: ingredient.brand,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Nutritional values (per 100g)',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _MacroCardsRow(ingredient: ingredient),

                  const SizedBox(height: 24),

                  _MicronutrientsDetail(ingredient: ingredient),

                  const SizedBox(height: 32),

                  _ActionButtons(
                    onEdit: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.ingredientEdit,
                        arguments: ingredient,
                      );
                    },
                    onDelete: () {
                      _showDeleteConfirmation(context, ingredient);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Ingredient ingredient) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete ingredient'),
        content: Text(
          'Are you sure you want to delete "${ingredient.name}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              IngredientService.instance.delete(ingredient.id);
              Navigator.pop(context); 
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}


// ── IMAGEN ──
class _IngredientDetailImage extends StatelessWidget {
  final String? imagePath;
  const _IngredientDetailImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Image.asset(
        imagePath ?? 'assets/images/placeholder_ingredient.png',
        fit: BoxFit.cover,
      ),
    );
  }
}


// ── NOMBRE Y MARCA ──
class _IngredientDetailHeader extends StatelessWidget {
  final String name;
  final String? brand;
  const _IngredientDetailHeader({required this.name, this.brand});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 24,
          ),
        ),
        if (brand != null) ...[
          const SizedBox(height: 4),
          Text(brand!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}


// ── FILA DE MACROS ──
class _MacroCardsRow extends StatelessWidget {
  final Ingredient ingredient;
  const _MacroCardsRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MacroCard(
          label: 'CALORIES',
          value: ingredient.calories.toStringAsFixed(0),
          unit: 'kcal',
        )),
        const SizedBox(width: 10),
        Expanded(child: _MacroCard(
          label: 'PROTEIN',
          value: ingredient.protein.toStringAsFixed(1),
          unit: 'g',
        )),
        const SizedBox(width: 10),
        Expanded(child: _MacroCard(
          label: 'CARBS',
          value: ingredient.carbs.toStringAsFixed(1),
          unit: 'g',
        )),
        const SizedBox(width: 10),
        Expanded(child: _MacroCard(
          label: 'FATS',
          value: ingredient.fats.toStringAsFixed(1),
          unit: 'g',
        )),
      ],
    );
  }
}


// ── TARJETA INDIVIDUAL ──
class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _MacroCard({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


// ── MICRONUTRIENTES ──
class _MicronutrientsDetail extends StatefulWidget {
  final Ingredient ingredient;
  const _MicronutrientsDetail({required this.ingredient});

  @override
  State<_MicronutrientsDetail> createState() => _MicronutrientsDetailState();
}

class _MicronutrientsDetailState extends State<_MicronutrientsDetail> {
  bool _expanded = false;

  bool get _hasMicronutrients =>
      widget.ingredient.fiber != null ||
      widget.ingredient.sugar != null ||
      widget.ingredient.sodium != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasMicronutrients) return const SizedBox.shrink();

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Micronutrients',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 15,
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                if (widget.ingredient.fiber != null)
                  _MicroRow(
                    label: 'Fiber',
                    value: widget.ingredient.fiber!.toStringAsFixed(1),
                    unit: 'g',
                  ),
                if (widget.ingredient.sugar != null)
                  _MicroRow(
                    label: 'Sugar',
                    value: widget.ingredient.sugar!.toStringAsFixed(1),
                    unit: 'g',
                  ),
                if (widget.ingredient.sodium != null)
                  _MicroRow(
                    label: 'Sodium',
                    value: widget.ingredient.sodium!.toStringAsFixed(0),
                    unit: 'mg',
                  ),
              ],
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}


// ── FILA DE MICRONUTRIENTE ──
class _MicroRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _MicroRow({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Text('$value $unit', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}


// ── BOTONES ──
class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ActionButtons({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Edit ingredient'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline_rounded,
              size: 18, color: Colors.red.shade400),
          label: Text(
            'Delete ingredient',
            style: TextStyle(color: Colors.red.shade400),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.red.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}