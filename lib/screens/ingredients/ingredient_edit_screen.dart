import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/ingredient.dart';
import '../../services/ingredient_service.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/smart_image.dart';
import '../../widgets/inputs/custom_text_field.dart';

class IngredientEditScreen extends StatefulWidget {
  const IngredientEditScreen({super.key});

  @override
  State<IngredientEditScreen> createState() => _IngredientEditScreenState();
}

class _IngredientEditScreenState extends State<IngredientEditScreen> {

  final _service = IngredientService.instance;
  Ingredient? _ingredient;

  File? _newImage;

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;
  late TextEditingController _fiberController;
  late TextEditingController _sugarController;
  late TextEditingController _sodiumController;

  bool _micronutrientsExpanded = false;
  final Map<String, String?> _errors = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ingredient != null) return;

    _ingredient =
        ModalRoute.of(context)!.settings.arguments as Ingredient;

    _nameController = TextEditingController(text: _ingredient!.name);
    _brandController =
        TextEditingController(text: _ingredient!.brand ?? '');
    _caloriesController = TextEditingController(
      text: _ingredient!.calories.toStringAsFixed(0),
    );
    _proteinController = TextEditingController(
      text: _ingredient!.protein.toStringAsFixed(1),
    );
    _carbsController = TextEditingController(
      text: _ingredient!.carbs.toStringAsFixed(1),
    );
    _fatsController = TextEditingController(
      text: _ingredient!.fats.toStringAsFixed(1),
    );
    _fiberController = TextEditingController(
      text: _ingredient!.fiber?.toStringAsFixed(1) ?? '',
    );
    _sugarController = TextEditingController(
      text: _ingredient!.sugar?.toStringAsFixed(1) ?? '',
    );
    _sodiumController = TextEditingController(
      text: _ingredient!.sodium?.toStringAsFixed(0) ?? '',
    );

    if (_ingredient!.fiber != null ||
        _ingredient!.sugar != null ||
        _ingredient!.sodium != null) {
      _micronutrientsExpanded = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
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
                  setState(() => _newImage = File(picked.path));
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
                  setState(() => _newImage = File(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateAll() {
    final newErrors = <String, String?>{};
    newErrors['name'] = Validators.validateName(_nameController.text);
    newErrors['calories'] = Validators.validatePositiveNumber(
      _caloriesController.text, 'Calories',
    );
    newErrors['protein'] = Validators.validatePositiveNumber(
      _proteinController.text, 'Protein',
    );
    newErrors['carbs'] = Validators.validatePositiveNumber(
      _carbsController.text, 'Carbohydrates',
    );
    newErrors['fats'] = Validators.validatePositiveNumber(
      _fatsController.text, 'Fats',
    );
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

  Future<void> _onSaveChanges() async {
    if (!_validateAll()) return;

    await _service.update(
      id: _ingredient!.id,
      imagePath: _newImage?.path ?? _ingredient!.imagePath,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      calories: double.parse(_caloriesController.text.trim()),
      protein: double.parse(_proteinController.text.trim()),
      carbs: double.parse(_carbsController.text.trim()),
      fats: double.parse(_fatsController.text.trim()),
      fiber: _fiberController.text.trim().isEmpty
          ? null
          : double.tryParse(_fiberController.text.trim()),
      sugar: _sugarController.text.trim().isEmpty
          ? null
          : double.tryParse(_sugarController.text.trim()),
      sodium: _sodiumController.text.trim().isEmpty
          ? null
          : double.tryParse(_sodiumController.text.trim()),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_ingredient == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit ingredient'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            _EditableImage(
              originalPath: _ingredient!.imagePath,
              newImage: _newImage,
              onTap: _pickImage,
            ),
            const SizedBox(height: 20),

            _FieldWithError(
              error: _errors['name'],
              child: CustomTextField(
                label: 'Ingredient name *',
                hint: 'e.g. Whole Milk',
                prefixIcon: Icons.label_outline_rounded,
                controller: _nameController,
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Brand name (optional)',
              hint: 'e.g. Organic Valley',
              prefixIcon: Icons.storefront_outlined,
              controller: _brandController,
            ),
            const SizedBox(height: 24),

            Text(
              'Nutrition per 100g',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),

            _FieldWithError(
              error: _errors['calories'],
              child: CustomTextField(
                label: 'Calories (kcal) *',
                hint: '0',
                prefixIcon: Icons.local_fire_department_outlined,
                controller: _caloriesController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _FieldWithError(
                    error: _errors['protein'],
                    child: CustomTextField(
                      label: 'Protein (g) *',
                      hint: '0',
                      prefixIcon: Icons.fitness_center_outlined,
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FieldWithError(
                    error: _errors['carbs'],
                    child: CustomTextField(
                      label: 'Carbs (g) *',
                      hint: '0',
                      prefixIcon: Icons.grain_outlined,
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _FieldWithError(
              error: _errors['fats'],
              child: CustomTextField(
                label: 'Fats (g) *',
                hint: '0',
                prefixIcon: Icons.opacity_outlined,
                controller: _fatsController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 24),

            _EditMicronutrientsSection(
              expanded: _micronutrientsExpanded,
              onToggle: () => setState(() {
                _micronutrientsExpanded = !_micronutrientsExpanded;
              }),
              fiberController: _fiberController,
              sugarController: _sugarController,
              sodiumController: _sodiumController,
            ),
            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Save changes',
              onPressed: _onSaveChanges,
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _EditableImage extends StatelessWidget {
  final String? originalPath;
  final File? newImage;
  final VoidCallback onTap;

  const _EditableImage({
    required this.onTap,
    this.originalPath,
    this.newImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        newImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  newImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : SmartImage(
                imagePath: originalPath,
                placeholder: 'assets/images/placeholder_ingredient.png',
                height: 180,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),

        Positioned(
          bottom: 12,
          right: 12,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
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


class _EditMicronutrientsSection extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final TextEditingController fiberController;
  final TextEditingController sugarController;
  final TextEditingController sodiumController;

  const _EditMicronutrientsSection({
    required this.expanded,
    required this.onToggle,
    required this.fiberController,
    required this.sugarController,
    required this.sodiumController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Micronutrients (optional)',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 15,
                  ),
                ),
                Icon(
                  expanded
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
          crossFadeState: expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Fiber (g)',
                  hint: '0.0',
                  prefixIcon: Icons.grass_outlined,
                  controller: fiberController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Sugar (g)',
                  hint: '0.0',
                  prefixIcon: Icons.cake_outlined,
                  controller: sugarController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Sodium (mg)',
                  hint: '0',
                  prefixIcon: Icons.water_drop_outlined,
                  controller: sodiumController,
                  keyboardType: TextInputType.number,
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