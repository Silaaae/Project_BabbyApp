import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../services/food_service.dart';
import '../../models/food_model.dart';
import '../../widgets/loading_widget.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<Food> _allFoods = [];
  List<Food> _suitableFoods = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'fruits',
    'vegetables',
    'cereals',
    'proteins',
    'dairy',
  ];

  final Map<String, String> _categoryLabels = {
    'all': 'Tous',
    'fruits': 'Fruits',
    'vegetables': 'Légumes',
    'cereals': 'Céréales',
    'proteins': 'Protéines',
    'dairy': 'Laitiers',
  };

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    if (babyProvider.selectedBaby != null) {
      try {
        final foods = await FoodService.getBabyFoods(
          babyProvider.selectedBaby!.id,
        );
        setState(() {
          _allFoods = foods;
          _filterFoods();
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterFoods() {
    if (_selectedCategory == 'all') {
      _suitableFoods = _allFoods;
    } else {
      _suitableFoods = _allFoods
          .where((food) => food.category == _selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final babyProvider = Provider.of<BabyProvider>(context);
    final baby = babyProvider.selectedBaby;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alimentation'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : baby == null
          ? const Center(child: Text('Aucun bébé sélectionné'))
          : Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _suitableFoods.isEmpty
                ? _buildEmptyState()
                : _buildFoodList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_categoryLabels[category]!),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                  _filterFoods();
                });
              },
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun aliment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aucun aliment adapté à cette catégorie',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suitableFoods.length,
      itemBuilder: (context, index) {
        final food = _suitableFoods[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(food.category),
              child: Icon(
                _getCategoryIcon(food.category),
                color: Colors.white,
              ),
            ),
            title: Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('À partir de ${food.minAgeMonths} mois'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (food.description != null) ...[
                      Text(
                        food.description!,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (food.preparationTips != null) ...[
                      _buildInfoSection(
                        'Préparation',
                        food.preparationTips!,
                        Icons.restaurant,

                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (food.allergens != null && food.allergens!.isNotEmpty) ...[
                      _buildInfoSection(
                        'Allergènes',
                        food.allergens!,
                        Icons.warning,
                        AppTheme.errorColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
      String title,
      String content,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'fruits':
        return Colors.red;
      case 'vegetables':
        return Colors.green;
      case 'cereals':
        return Colors.amber;
      case 'proteins':
        return Colors.brown;
      case 'dairy':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'cereals':
        return Icons.grain;
      case 'proteins':
        return Icons.restaurant;
      case 'dairy':
        return Icons.coffee;
      default:
        return Icons.fastfood;
    }
  }
}