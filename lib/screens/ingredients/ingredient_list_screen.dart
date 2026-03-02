import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../models/ingredient.dart';
import '../../services/ingredient_service.dart';
import '../../widgets/cards/ingredient_card.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key});

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {

  final _service = IngredientService.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Ingredient> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadIngredients() {
    setState(() => _ingredients = _service.getAll());
  }

  void _onSearch(String query) {
    setState(() => _ingredients = _service.search(query));
  }

  Future<void> _onAddIngredient() async {
    await Navigator.pushNamed(context, AppRoutes.ingredientScanner);
    _loadIngredients();
  }

  Future<void> _onIngredientTapped(Ingredient ingredient) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.ingredientDetail,
      arguments: ingredient,
    );
    _loadIngredients();
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
              hintText: 'Search ingredients...',
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
        childAspectRatio: 1 / 1.3,
      ),
      itemCount: _ingredients.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildAddCard();
        final ingredient = _ingredients[index - 1];
        return IngredientCard(
          name: ingredient.name,
          brand: ingredient.brand,
          imagePath: ingredient.imagePath,
          onTap: () => _onIngredientTapped(ingredient),
        );
      },
    );
  }

  Widget _buildAddCard() {
    return InkWell(
      onTap: _onAddIngredient,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text('Add Ingredient',
                style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}