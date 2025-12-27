import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/baby_provider.dart';
import '../../models/food_model.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Fruits',
      'icon': '🍎',
      'key': 'fruits',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    },
    {
      'name': 'Légumes',
      'icon': '🥕',
      'key': 'vegetables',
      'gradient': [Color(0xFF4CAF50), Color(0xFF45B7D1)],
    },
    {
      'name': 'Céréales',
      'icon': '🌾',
      'key': 'cereals',
      'gradient': [Color(0xFFFFB74D), Color(0xFFFFA726)],
    },
    {
      'name': 'Protéines',
      'icon': '🍗',
      'key': 'proteins',
      'gradient': [Color(0xFFE91E63), Color(0xFFEC407A)],
    },
    {
      'name': 'Laitiers',
      'icon': '🥛',
      'key': 'dairy',
      'gradient': [Color(0xFF2196F3), Color(0xFF42A5F5)],
    },
  ];

  late List<Food> allFoods;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategoryIndex = _tabController.index;
        });
      }
    });

    // --- Liste complète des aliments avec notes et quantités ---
    allFoods = [
      // Fruits
      Food(id: 1, name: 'Banane', minAgeMonths: 6, category: 'fruits', emoji: '🍌', note: 'Écrasée en purée', quantity: '2-3 c. à soupe'),
      Food(id: 2, name: 'Pomme', minAgeMonths: 6, category: 'fruits', emoji: '🍎', note: 'Cuire puis écraser', quantity: '2-3 c. à soupe'),
      Food(id: 3, name: 'Poire', minAgeMonths: 6, category: 'fruits', emoji: '🍐', note: 'Purée ou compote', quantity: '2-3 c. à soupe'),
      Food(id: 4, name: 'Avocat', minAgeMonths: 6, category: 'fruits', emoji: '🥑', note: 'Écrasé', quantity: '1/4 de fruit'),
      Food(id: 5, name: 'Mangue', minAgeMonths: 8, category: 'fruits', emoji: '🥭', note: 'Purée lisse', quantity: '2 c. à soupe'),
      Food(id: 6, name: 'Pêche', minAgeMonths: 8, category: 'fruits', emoji: '🍑', note: 'Purée ou compote', quantity: '2 c. à soupe'),
      Food(id: 7, name: 'Framboise', minAgeMonths: 8, category: 'fruits', emoji: '🍓', note: 'Purée', quantity: '2 c. à soupe'),
      Food(id: 8, name: 'Myrtille', minAgeMonths: 8, category: 'fruits', emoji: '🫐', note: 'Purée', quantity: '2 c. à soupe'),
      Food(id: 9, name: 'Kiwi', minAgeMonths: 10, category: 'fruits', emoji: '🥝', note: 'Purée ou petits morceaux fondants', quantity: '1/2 fruit'),

      // Légumes
      Food(id: 10, name: 'Carotte', minAgeMonths: 6, category: 'vegetables', emoji: '🥕', note: 'Cuire vapeur puis écraser', quantity: '2-3 c. à soupe'),
      Food(id: 11, name: 'Courgette', minAgeMonths: 6, category: 'vegetables', emoji: '🥒', note: 'Cuire puis purée', quantity: '2-3 c. à soupe'),
      Food(id: 12, name: 'Brocoli', minAgeMonths: 8, category: 'vegetables', emoji: '🥦', note: 'Cuire vapeur, petits morceaux', quantity: '2-3 c. à soupe'),
      Food(id: 13, name: 'Patate douce', minAgeMonths: 6, category: 'vegetables', emoji: '🍠', note: 'Purée lisse', quantity: '2-3 c. à soupe'),
      Food(id: 14, name: 'Épinards', minAgeMonths: 8, category: 'vegetables', emoji: '🌿', note: 'Purée', quantity: '2-3 c. à soupe'),
      Food(id: 15, name: 'Petit pois', minAgeMonths: 8, category: 'vegetables', emoji: '🟢', note: 'Purée lisse', quantity: '2-3 c. à soupe'),
      Food(id: 16, name: 'Potiron', minAgeMonths: 8, category: 'vegetables', emoji: '🎃', note: 'Purée', quantity: '2-3 c. à soupe'),
      Food(id: 17, name: 'Tomate', minAgeMonths: 8, category: 'vegetables', emoji: '🍅', note: 'Purée cuite', quantity: '2-3 c. à soupe'),

      // Céréales
      Food(id: 18, name: 'Riz', minAgeMonths: 6, category: 'cereals', emoji: '🍚', note: 'Bien cuit et mixé', quantity: '2-3 c. à soupe'),
      Food(id: 19, name: 'Avoine', minAgeMonths: 6, category: 'cereals', emoji: '🌾', note: 'Purée lisse', quantity: '2-3 c. à soupe'),
      Food(id: 20, name: 'Quinoa', minAgeMonths: 8, category: 'cereals', emoji: '🍽️', note: 'Bien cuit, écrasé', quantity: '2-3 c. à soupe'),
      Food(id: 21, name: 'Semoule', minAgeMonths: 6, category: 'cereals', emoji: '🥣', note: 'Purée lisse', quantity: '2-3 c. à soupe'),
      Food(id: 22, name: 'Pain complet', minAgeMonths: 8, category: 'cereals', emoji: '🍞', note: 'Petits morceaux mous', quantity: '1-2 morceaux'),
      Food(id: 23, name: 'Pâtes', minAgeMonths: 8, category: 'cereals', emoji: '🍝', note: 'Petits morceaux tendres', quantity: '2-3 c. à soupe'),

      // Protéines
      Food(id: 24, name: 'Poulet', minAgeMonths: 10, category: 'proteins', emoji: '🍗', note: 'Bien cuit et émietté', quantity: '2-3 c. à soupe'),
      Food(id: 25, name: 'Dinde', minAgeMonths: 10, category: 'proteins', emoji: '🦃', note: 'Émietté', quantity: '2-3 c. à soupe'),
      Food(id: 26, name: 'Poisson blanc', minAgeMonths: 10, category: 'proteins', emoji: '🐟', note: 'Bien cuit, émietté', quantity: '2-3 c. à soupe'),
      Food(id: 27, name: 'Œuf (jaune uniquement)', minAgeMonths: 8, category: 'proteins', emoji: '🥚', note: 'Purée ou jaune cuit dur', quantity: '1 jaune'),
      Food(id: 28, name: 'Lentilles', minAgeMonths: 8, category: 'proteins', emoji: '🥫', note: 'Bien cuites et mixées', quantity: '2-3 c. à soupe'),
      Food(id: 29, name: 'Haricots', minAgeMonths: 10, category: 'proteins', emoji: '🫘', note: 'Bien cuits et écrasés', quantity: '2-3 c. à soupe'),

      // Laitiers
      Food(id: 30, name: 'Yaourt nature', minAgeMonths: 8, category: 'dairy', emoji: '🥛', note: 'Non sucré, à température ambiante', quantity: '50-80g'),
      Food(id: 31, name: 'Fromage doux', minAgeMonths: 12, category: 'dairy', emoji: '🧀', note: 'Petits morceaux fondants', quantity: '10-20g'),
      Food(id: 32, name: 'Fromage râpé', minAgeMonths: 12, category: 'dairy', emoji: '🧀', note: 'Ajouter à purée ou légumes', quantity: '5-10g'),
      Food(id: 33, name: 'Petit suisse', minAgeMonths: 8, category: 'dairy', emoji: '🥛', note: 'Non sucré, à température ambiante', quantity: '50g'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baby = context.watch<BabyProvider>().selectedBaby;
    final currentCategory = categories[_selectedCategoryIndex];
    final categoryFoods = allFoods.where((f) => f.category == currentCategory['key']).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(baby, currentCategory),
            _buildCategorySelector(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categoryFoods.length,
                itemBuilder: (context, index) {
                  final food = categoryFoods[index];
                  return _buildFoodRow(food, currentCategory, baby);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(baby, Map<String, dynamic> category) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: category['gradient'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          BackButton(color: Colors.white),
          const SizedBox(width: 8),
          Text(category['icon'], style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          const Text('Alimentation', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          if (baby != null) Text('${baby.name} • ${baby.ageInMonths} mois', style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              _tabController.animateTo(index);
              setState(() => _selectedCategoryIndex = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 100 : 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                    colors: category['gradient'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category['icon'], style: TextStyle(fontSize: isSelected ? 36 : 28)),
                  const SizedBox(height: 8),
                  Text(category['name'], style: TextStyle(fontSize: isSelected ? 13 : 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey[700])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodRow(Food food, Map<String, dynamic> category, baby) {
    final isRecommended = baby != null && food.minAgeMonths <= baby.ageInMonths;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(12),
        border: isRecommended ? Border.all(color: (category['gradient'] as List<Color>)[0], width: 2) : null,
      ),
      child: Row(
        children: [
          Text(food.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${food.minAgeMonths}+ mois • ${food.note} • Quantité: ${food.quantity}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          if (isRecommended) const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }
}