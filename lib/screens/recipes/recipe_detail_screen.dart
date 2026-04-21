import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/smart_image.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late Recipe _recipe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete recipe'),
        content: Text(
          'Are you sure you want to delete "${_recipe.name}"? '
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
            onPressed: () async {
              final navigator = Navigator.of(context);
              await RecipeService.instance.delete(_recipe.id);
              if (!mounted) return;
              navigator.pop(); // cierra el diálogo
              navigator.pop(); // vuelve al listado
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'BookCook'),

      // PAPELERA
      floatingActionButton: FloatingActionButton(
        onPressed: _showDeleteConfirmation,
        backgroundColor: Colors.red.shade400,
        mini: true,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),

      body: Column(
        children: [
          _RecipeImage(imagePath: _recipe.imagePath),
          _RecipeName(name: _recipe.name),
          _RecipeTabBar(tabController: _tabController),
          Expanded(
            child: _RecipeTabContent(
              tabController: _tabController,
              recipe: _recipe,
            ),
          ),
        ],
      ),
    );
  }
}


class _RecipeImage extends StatelessWidget {
  final String? imagePath;
  const _RecipeImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SmartImage(
      imagePath: imagePath,
      placeholder: 'assets/images/placeholder_recipe.png',
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}


class _RecipeName extends StatelessWidget {
  final String name;
  const _RecipeName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}


class _RecipeTabBar extends StatelessWidget {
  final TabController tabController;
  const _RecipeTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Theme.of(context).colorScheme.primary,
      indicatorWeight: 2,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: const TextStyle(fontSize: 14),
      tabs: const [
        Tab(text: 'Ingredients'),
        Tab(text: 'Steps'),
        Tab(text: 'Nutrition'),
      ],
    );
  }
}


class _RecipeTabContent extends StatelessWidget {
  final TabController tabController;
  final Recipe recipe;
  const _RecipeTabContent({
    required this.tabController,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _IngredientsTab(recipe: recipe),
        _StepsTab(recipe: recipe),
        _NutritionTab(recipe: recipe),
      ],
    );
  }
}


class _IngredientsTab extends StatelessWidget {
  final Recipe recipe;
  const _IngredientsTab({required this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe.ingredients.isEmpty) {
      return Center(
        child: Text('No ingredients',
            style: Theme.of(context).textTheme.bodyMedium),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: recipe.ingredients.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final ri = recipe.ingredients[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ri.ingredient.name,
                  style: Theme.of(context).textTheme.labelMedium),
              Text(
                ri.quantity.isEmpty ? '—' : ri.quantity,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}


class _StepsTab extends StatelessWidget {
  final Recipe recipe;
  const _StepsTab({required this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe.steps.isEmpty) {
      return Center(
        child: Text('No steps',
            style: Theme.of(context).textTheme.bodyMedium),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recipe.steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 14, top: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  recipe.steps[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class _NutritionTab extends StatelessWidget {
  final Recipe recipe;
  const _NutritionTab({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NutritionHighlight(
            label: 'Calories',
            value: recipe.totalCalories.toStringAsFixed(0),
            unit: 'kcal',
          ),
          const SizedBox(height: 20),
          Text('Macronutrients',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 15,
              )),
          const SizedBox(height: 12),
          _NutritionRow(
            label: 'Protein',
            value: recipe.totalProtein.toStringAsFixed(1),
            unit: 'g',
          ),
          _NutritionRow(
            label: 'Carbohydrates',
            value: recipe.totalCarbs.toStringAsFixed(1),
            unit: 'g',
          ),
          _NutritionRow(
            label: 'Fats',
            value: recipe.totalFats.toStringAsFixed(1),
            unit: 'g',
          ),
        ],
      ),
    );
  }
}


class _NutritionHighlight extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _NutritionHighlight({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _NutritionRow({
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
          Text('$value $unit',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}