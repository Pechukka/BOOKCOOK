import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../services/ingredient_service.dart';
import '../../services/open_food_service.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/smart_image.dart';
import '../../widgets/inputs/custom_text_field.dart';

class IngredientConfirmScreen extends StatefulWidget {
  const IngredientConfirmScreen({super.key});

  @override
  State<IngredientConfirmScreen> createState() =>
      _IngredientConfirmScreenState();
}

class _IngredientConfirmScreenState extends State<IngredientConfirmScreen> {

  final _service = IngredientService.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _fiberController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();

  bool _micronutrientsExpanded = false;
  bool _productFound = false;
  bool _initialized = false;
  String? _imageUrl;
  final Map<String, String?> _errors = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final result = ModalRoute.of(context)?.settings.arguments;

    if (result is OpenFoodResult) {
      _productFound = true;
      _imageUrl = result.imageUrl.isNotEmpty ? result.imageUrl : null;
      _nameController.text = result.name;
      _brandController.text = result.brand;
      _caloriesController.text = result.calories?.toStringAsFixed(0) ?? '';
      _proteinController.text = result.protein?.toStringAsFixed(1) ?? '';
      _carbsController.text = result.carbs?.toStringAsFixed(1) ?? '';
      _fatsController.text = result.fats?.toStringAsFixed(1) ?? '';
      _fiberController.text = result.fiber?.toStringAsFixed(1) ?? '';
      _sugarController.text = result.sugar?.toStringAsFixed(1) ?? '';
      _sodiumController.text = result.sodium?.toStringAsFixed(0) ?? '';

      if (result.fiber != null ||
          result.sugar != null ||
          result.sodium != null) {
        _micronutrientsExpanded = true;
      }
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
    return newErrors.values.every((error) => error == null);
  }

  Future<void> _onSaveIngredient() async {
    if (!_validateAll()) return;

    await _service.create(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      imagePath: _imageUrl,
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

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => route.isFirst,
      );
    }
  }

  void _onScanAnother() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Confirm ingredient'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            _productFound
                ? _ProductFoundBanner()
                : _ProductNotFoundBanner(),
            const SizedBox(height: 20),

            _ProductImage(imageUrl: _imageUrl),
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

            _SectionTitle(title: 'Nutrition per 100g'),
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

            _MicronutrientsSection(
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
              text: 'Save ingredient',
              onPressed: _onSaveIngredient,
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: _onScanAnother,
              child: Text(
                'Scan another product',
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


class _ProductFoundBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: Colors.green.shade500, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product found',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Review the information and save',
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ProductNotFoundBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.red.shade400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product not found',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Please enter the ingredient information manually',
                  style: TextStyle(color: Colors.red.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SmartImage(
      imagePath: imageUrl,
      placeholder: 'assets/images/placeholder_ingredient.png',
      height: 180,
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontSize: 15,
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


class _MicronutrientsSection extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final TextEditingController fiberController;
  final TextEditingController sugarController;
  final TextEditingController sodiumController;

  const _MicronutrientsSection({
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
                _SectionTitle(title: 'Add micronutrients (optional)'),
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