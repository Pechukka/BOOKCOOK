import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import '../../widgets/cards/recipe_card.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {

  final _service = RecipeService.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRecipes() {
    setState(() => _recipes = _service.getAll());
  }

  void _onSearch(String query) {
    setState(() => _recipes = _service.search(query));
  }

  Future<void> _onAddRecipe() async {
    await Navigator.pushNamed(context, AppRoutes.recipeAdd);
    _loadRecipes();
  }

  Future<void> _onRecipeTapped(Recipe recipe) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: recipe,
    );
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    // Sin Scaffold — HomeScreen ya proporciona el Scaffold con AppBar y Drawer
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearch,
            decoration: const InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: Icon(Icons.search_rounded),
              suffixIcon: Icon(Icons.tune_rounded),
            ),
          ),
        ),
        Expanded(child: _buildGrid()),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1 / 1.2,
      ),
      itemCount: _recipes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildAddCard();
        final recipe = _recipes[index - 1];
        return RecipeCard(
          name: recipe.name,
          imagePath: recipe.imagePath,
          onTap: () => _onRecipeTapped(recipe),
        );
      },
    );
  }

  Widget _buildAddCard() {
    return InkWell(
      onTap: _onAddRecipe,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text('Add Recipe',
                style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}