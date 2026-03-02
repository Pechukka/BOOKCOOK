import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../services/ingredient_service.dart';
import '../../services/recipe_service.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/inputs/custom_text_field.dart';

class RecipeAddScreen extends StatefulWidget {
  const RecipeAddScreen({super.key});

  @override
  State<RecipeAddScreen> createState() => _RecipeAddScreenState();
}

class _RecipeAddScreenState extends State<RecipeAddScreen> {

  final _recipeService = RecipeService.instance;
  final _ingredientService = IngredientService.instance;

  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _stepControllers = [
    TextEditingController(),
  ];

  final List<RecipeIngredient> _selectedIngredients = [];
  final Map<String, String?> _errors = {};

  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 800,
                );
                if (picked != null && mounted) {
                  setState(() => _selectedImage = File(picked.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 800,
                );
                if (picked != null && mounted) {
                  setState(() => _selectedImage = File(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addStep() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  void _removeIngredient(int index) {
    setState(() => _selectedIngredients.removeAt(index));
  }

  void _updateQuantity(int index, String quantity) {
    setState(() {
      _selectedIngredients[index] = RecipeIngredient(
        ingredient: _selectedIngredients[index].ingredient,
        quantity: quantity,
      );
    });
  }

  void _showIngredientSelector() {
    final availableIngredients = _ingredientService.getAll();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return _IngredientSelectorModal(
              scrollController: scrollController,
              ingredients: availableIngredients,
              onIngredientSelected: (ingredient) {
                Navigator.pop(modalContext);
                setState(() {
                  _selectedIngredients.add(
                    RecipeIngredient(ingredient: ingredient, quantity: ''),
                  );
                });
              },
            );
          },
        );
      },
    );
  }

  bool _validateAll() {
    final newErrors = <String, String?>{};
    newErrors['name'] = Validators.validateName(_nameController.text);
    newErrors['ingredients'] =
        _selectedIngredients.isEmpty ? 'Add at least one ingredient' : null;
    newErrors['steps'] =
        Validators.validateStep(_stepControllers.first.text);
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

  Future<void> _onSaveRecipe() async {
    if (!_validateAll()) return;

    final steps = _stepControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    await _recipeService.create(
      name: _nameController.text.trim(),
      ingredients: _selectedIngredients,
      steps: steps,
      imagePath: _selectedImage?.path, 
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Recipe'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            _buildPhotoArea(context),
            const SizedBox(height: 20),

            _FieldWithError(
              error: _errors['name'],
              child: CustomTextField(
                label: '',
                hint: 'Recipe name',
                prefixIcon: Icons.edit_outlined,
                controller: _nameController,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Ingredients', _showIngredientSelector),

            if (_errors['ingredients'] != null) ...[
              const SizedBox(height: 6),
              Text(_errors['ingredients']!,
                  style: TextStyle(color: Colors.red.shade600, fontSize: 12)),
            ],

            const SizedBox(height: 12),
            ..._buildIngredientRows(context),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Steps', _addStep),

            if (_errors['steps'] != null) ...[
              const SizedBox(height: 6),
              Text(_errors['steps']!,
                  style: TextStyle(color: Colors.red.shade600, fontSize: 12)),
            ],

            const SizedBox(height: 12),
            ..._buildStepRows(context),
            const SizedBox(height: 24),

            _buildNutritionPreview(context),
            const SizedBox(height: 32),

            PrimaryButton(text: 'Save Recipe', onPressed: _onSaveRecipe),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_rounded,
                      size: 36,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5)),
                  const SizedBox(height: 8),
                  Text('Add recipe photo',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onAdd,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 16,
            )),
        TextButton.icon(
          onPressed: onAdd,
          icon: Icon(Icons.add_circle_outline_rounded,
              size: 18, color: Theme.of(context).colorScheme.primary),
          label: Text('Add',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              )),
        ),
      ],
    );
  }

  List<Widget> _buildIngredientRows(BuildContext context) {
    if (_selectedIngredients.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'No ingredients yet. Tap + Add to select from your ingredients.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }

    return _selectedIngredients.asMap().entries.map((entry) {
      final index = entry.key;
      final recipeIngredient = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text('${index + 1}.',
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipeIngredient.ingredient.name,
                        style: Theme.of(context).textTheme.labelMedium),
                    if (recipeIngredient.ingredient.brand != null)
                      Text(recipeIngredient.ingredient.brand!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Qty',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  onChanged: (value) => _updateQuantity(index, value),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _removeIngredient(index),
                child: Icon(Icons.close_rounded,
                    size: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.5)),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildStepRows(BuildContext context) {
    return _stepControllers.asMap().entries.map((entry) {
      final index = entry.key;
      final controller = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(top: 10, right: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                decoration:
                    InputDecoration(hintText: 'Describe step ${index + 1}...'),
              ),
            ),
            if (_stepControllers.length > 1)
              GestureDetector(
                onTap: () => _removeStep(index),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8),
                  child: Icon(Icons.close_rounded,
                      size: 18,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5)),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildNutritionPreview(BuildContext context) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (final ri in _selectedIngredients) {
      totalCalories += ri.ingredient.calories;
      totalProtein += ri.ingredient.protein;
      totalCarbs += ri.ingredient.carbs;
      totalFats += ri.ingredient.fats;
    }

    final hasIngredients = _selectedIngredients.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nutrition Preview',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 15,
              )),
          const SizedBox(height: 4),
          Text('Estimated values based on ingredients',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NutritionChip(
                value: hasIngredients
                    ? totalCalories.toStringAsFixed(0)
                    : '—',
                label: 'kcal',
              ),
              _NutritionChip(
                value: hasIngredients
                    ? totalProtein.toStringAsFixed(1)
                    : '—',
                label: 'Protein',
              ),
              _NutritionChip(
                value: hasIngredients ? totalCarbs.toStringAsFixed(1) : '—',
                label: 'Carbs',
              ),
              _NutritionChip(
                value: hasIngredients ? totalFats.toStringAsFixed(1) : '—',
                label: 'Fats',
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _NutritionChip extends StatelessWidget {
  final String value;
  final String label;
  const _NutritionChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
              )),
        ],
      ),
    );
  }
}


class _IngredientSelectorModal extends StatefulWidget {
  final ScrollController scrollController;
  final List<Ingredient> ingredients;
  final void Function(Ingredient) onIngredientSelected;

  const _IngredientSelectorModal({
    required this.scrollController,
    required this.ingredients,
    required this.onIngredientSelected,
  });

  @override
  State<_IngredientSelectorModal> createState() =>
      _IngredientSelectorModalState();
}

class _IngredientSelectorModalState extends State<_IngredientSelectorModal> {

  late List<Ingredient> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.ingredients;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filtered = widget.ingredients;
      } else {
        final q = query.toLowerCase();
        _filtered = widget.ingredients
            .where((i) =>
                i.name.toLowerCase().contains(q) ||
                (i.brand?.toLowerCase().contains(q) ?? false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select ingredient',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: _onSearch,
              decoration: const InputDecoration(
                hintText: 'Search ingredient...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.egg_outlined,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          widget.ingredients.isEmpty
                              ? 'No ingredients saved yet'
                              : 'No results found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (widget.ingredients.isEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Add ingredients from the Ingredients tab first',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final ingredient = _filtered[index];
                      return GestureDetector(
                        onTap: () => widget.onIngredientSelected(ingredient),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    ingredient.imagePath ??
                                        'assets/images/placeholder_ingredient.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(ingredient.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      if (ingredient.brand != null)
                                        Text(ingredient.brand!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(fontSize: 11),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


class _FieldWithError extends StatelessWidget {
  final String? error;
  final Widget child;
  const _FieldWithError({required this.child, this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(error!,
              style: TextStyle(color: Colors.red.shade600, fontSize: 12)),
        ],
      ],
    );
  }
}