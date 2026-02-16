import 'package:flutter/material.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/cards/recipe_card.dart';
import '../../widgets/cards/ingredient_card.dart';
import '../../app/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> _mockRecipes = [
    {'name': 'Creamy Pasta', 'image': ''},
    {'name': 'Fluffy Pancakes', 'image': ''},
    {'name': 'Fresh Garden Salad', 'image': ''},
    {'name': 'Chocolate Cake', 'image': ''},
    {'name': 'Comfort Soup', 'image': ''},
  ];

  final List<Map<String, String>> _mockIngredients = [
    {'name': 'Whole Milk', 'brand': 'Organic Valley'},
    {'name': 'Chicken Breast', 'brand': 'Perdue'},
    {'name': 'Brown Rice', 'brand': 'Uncle Ben\'s'},
    {'name': 'Olive Oil', 'brand': 'Bertolli'},
    {'name': 'Cheddar Cheese', 'brand': 'Kraft'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'BookCook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _currentIndex == 0 ? _buildRecipesTab() : _buildIngredientsTab(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildRecipesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _mockRecipes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddRecipeCard();
              }
              final recipe = _mockRecipes[index - 1];
              return RecipeCard(
                name: recipe['name']!,
                imageUrl: recipe['image']!.isEmpty ? null : recipe['image'],
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.recipeDetail);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search ingredients...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _mockIngredients.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddIngredientCard();
              }
              final ingredient = _mockIngredients[index - 1];
              return IngredientCard(
                name: ingredient['name']!,
                brand: ingredient['brand'],
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddRecipeCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.addRecipe);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 48,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Recipe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIngredientCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.scanner);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 48,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Ingredient',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}