import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/baby_provider.dart';
import '../../models/food_model.dart';
import '../../services/food_service.dart';
import '../../config/theme.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<Food> allFoods = [];
  bool isLoading = true;
  int selectedMonth = 0;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    try {
      final foods = await FoodService.getFoods();
      setState(() {
        allFoods = foods;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Guide alimentaire complet par mois
  final Map<String, dynamic> foodGuide = {
    '0-3': {
      'title': '0-3 mois',
      'emoji': '🍼',
      'color': Color(0xFFE1BEE7),
      'mainColor': Color(0xFF9C27B0),
      'description': 'Allaitement ou lait infantile exclusif',
      'intro': 'Pendant les premiers mois, bébé n\'a besoin que de lait maternel ou de lait infantile. Aucun autre aliment n\'est nécessaire.',
      'categories': [
        {
          'name': 'Lait uniquement',
          'icon': '🍼',
          'items': [
            {
              'name': 'Lait maternel',
              'emoji': '🤱',
              'desc': '8 à 12 tétées par jour - Aliment parfait et complet',
              'qty': 'À la demande'
            },
            {
              'name': 'Lait infantile 1er âge',
              'emoji': '🍼',
              'desc': '6 à 8 biberons par jour de 90-120ml',
              'qty': '700-900ml/jour'
            },
          ]
        },
        {
          'name': 'Vitamines recommandées',
          'icon': '💊',
          'items': [
            {
              'name': 'Vitamine D',
              'emoji': '☀️',
              'desc': 'Supplément quotidien pour tous les bébés',
              'qty': '400-800 UI/jour'
            },
          ]
        }
      ]
    },
    '4-6': {
      'title': '4-6 mois',
      'emoji': '🥄',
      'color': Color(0xFFFFE0B2),
      'mainColor': Color(0xFFFF9800),
      'description': 'Début de la diversification alimentaire',
      'intro': 'Commencez la diversification entre 4 et 6 mois. Introduisez un nouvel aliment tous les 2-3 jours pour détecter les allergies.',
      'categories': [
        {
          'name': 'Premiers légumes',
          'icon': '🥕',
          'items': [
            {
              'name': 'Carotte',
              'emoji': '🥕',
              'desc': 'Purée lisse - Goût doux et légèrement sucré',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Courgette',
              'emoji': '🥒',
              'desc': 'Sans peau ni pépins - Très digeste',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Haricots verts',
              'emoji': '🫘',
              'desc': 'Bien mixés - Riches en fibres',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Patate douce',
              'emoji': '🍠',
              'desc': 'Texture crémeuse - Naturellement sucrée',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Potiron',
              'emoji': '🎃',
              'desc': 'Purée onctueuse - Facile à digérer',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Panais',
              'emoji': '🥕',
              'desc': 'Goût légèrement sucré - Bien toléré',
              'qty': '2-3 cuillères'
            },
          ]
        },
        {
          'name': 'Premiers fruits',
          'icon': '🍎',
          'items': [
            {
              'name': 'Pomme',
              'emoji': '🍎',
              'desc': 'Compote sans sucre - Cuite à la vapeur',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Poire',
              'emoji': '🍐',
              'desc': 'Très douce - Aide au transit',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Banane',
              'emoji': '🍌',
              'desc': 'Écrasée à la fourchette - Riche en potassium',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Pêche',
              'emoji': '🍑',
              'desc': 'Bien mûre et mixée - Vitaminée',
              'qty': '2-3 cuillères'
            },
            {
              'name': 'Abricot',
              'emoji': '🍑',
              'desc': 'Compote lisse - Riche en bêta-carotène',
              'qty': '2-3 cuillères'
            },
          ]
        },
        {
          'name': 'Céréales sans gluten',
          'icon': '🌾',
          'items': [
            {
              'name': 'Riz infantile',
              'emoji': '🍚',
              'desc': 'Enrichi en fer - Mélangé au lait',
              'qty': '1-2 cuillères'
            },
            {
              'name': 'Maïs',
              'emoji': '🌽',
              'desc': 'Farine infantile - Sans gluten',
              'qty': '1-2 cuillères'
            },
          ]
        },
        {
          'name': 'Lait',
          'icon': '🍼',
          'items': [
            {
              'name': 'Lait maternel ou 2e âge',
              'emoji': '🍼',
              'desc': 'Reste l\'aliment principal',
              'qty': '500-800ml/jour'
            },
          ]
        }
      ]
    },
    '7-9': {
      'title': '7-9 mois',
      'emoji': '🥣',
      'color': Color(0xFFC8E6C9),
      'mainColor': Color(0xFF4CAF50),
      'description': 'Introduction des protéines et nouvelles textures',
      'intro': 'Bébé peut maintenant manger des aliments écrasés. C\'est le moment d\'introduire les protéines (viande, poisson, œuf).',
      'categories': [
        {
          'name': 'Protéines animales',
          'icon': '🍗',
          'items': [
            {
              'name': 'Poulet',
              'emoji': '🍗',
              'desc': 'Mixé avec légumes - Blanc de poulet',
              'qty': '10g/jour'
            },
            {
              'name': 'Dinde',
              'emoji': '🦃',
              'desc': 'Viande maigre et tendre',
              'qty': '10g/jour'
            },
            {
              'name': 'Veau',
              'emoji': '🥩',
              'desc': 'Viande blanche mixée',
              'qty': '10g/jour'
            },
            {
              'name': 'Poisson blanc',
              'emoji': '🐟',
              'desc': 'Colin, cabillaud - Sans arêtes',
              'qty': '10g/jour'
            },
            {
              'name': 'Sole',
              'emoji': '🐠',
              'desc': 'Poisson maigre et doux',
              'qty': '10g/jour'
            },
            {
              'name': 'Jaune d\'œuf',
              'emoji': '🥚',
              'desc': 'Dur, bien cuit - Commencer par 1/4',
              'qty': '1/4 œuf'
            },
          ]
        },
        {
          'name': 'Légumes variés',
          'icon': '🥦',
          'items': [
            {
              'name': 'Brocoli',
              'emoji': '🥦',
              'desc': 'Fleurettes tendres - Riche en vitamines',
              'qty': '20-30g'
            },
            {
              'name': 'Chou-fleur',
              'emoji': '🥬',
              'desc': 'Bien cuit et écrasé',
              'qty': '20-30g'
            },
            {
              'name': 'Épinards',
              'emoji': '🥬',
              'desc': 'Riches en fer - Bien cuits',
              'qty': '20-30g'
            },
            {
              'name': 'Petits pois',
              'emoji': '🫛',
              'desc': 'Mixés au début puis écrasés',
              'qty': '20-30g'
            },
            {
              'name': 'Betterave',
              'emoji': '🥗',
              'desc': 'Naturellement sucrée',
              'qty': '20-30g'
            },
            {
              'name': 'Pomme de terre',
              'emoji': '🥔',
              'desc': 'Base pour les purées',
              'qty': '30-40g'
            },
            {
              'name': 'Aubergine',
              'emoji': '🍆',
              'desc': 'Sans peau - Bien cuite',
              'qty': '20-30g'
            },
          ]
        },
        {
          'name': 'Nouveaux fruits',
          'icon': '🍇',
          'items': [
            {
              'name': 'Prune',
              'emoji': '🫐',
              'desc': 'Aide au transit - Compote',
              'qty': '30-50g'
            },
            {
              'name': 'Melon',
              'emoji': '🍈',
              'desc': 'Bien mûr et mixé',
              'qty': '30-50g'
            },
            {
              'name': 'Mangue',
              'emoji': '🥭',
              'desc': 'Exotique et sucrée',
              'qty': '30-50g'
            },
            {
              'name': 'Kiwi',
              'emoji': '🥝',
              'desc': 'Riche en vitamine C',
              'qty': '30-50g'
            },
          ]
        },
        {
          'name': 'Féculents',
          'icon': '🍝',
          'items': [
            {
              'name': 'Pâtes fines',
              'emoji': '🍝',
              'desc': 'Alphabet, coquillettes - Très cuites',
              'qty': '20-30g'
            },
            {
              'name': 'Semoule',
              'emoji': '🥣',
              'desc': 'Fine et bien cuite',
              'qty': '20-30g'
            },
            {
              'name': 'Quinoa',
              'emoji': '🌾',
              'desc': 'Riche en protéines',
              'qty': '20-30g'
            },
            {
              'name': 'Pain',
              'emoji': '🍞',
              'desc': 'Croûte à mâchouiller',
              'qty': '10-15g'
            },
          ]
        },
        {
          'name': 'Matières grasses',
          'icon': '🧈',
          'items': [
            {
              'name': 'Huile d\'olive',
              'emoji': '🫒',
              'desc': 'Crue dans les purées',
              'qty': '1 cuillère à café'
            },
            {
              'name': 'Huile de colza',
              'emoji': '🌻',
              'desc': 'Riche en oméga-3',
              'qty': '1 cuillère à café'
            },
            {
              'name': 'Beurre',
              'emoji': '🧈',
              'desc': 'Doux, non salé',
              'qty': '5g'
            },
          ]
        },
        {
          'name': 'Lait',
          'icon': '🍼',
          'items': [
            {
              'name': 'Lait 2e âge',
              'emoji': '🍼',
              'desc': 'Enrichi en fer',
              'qty': '500-600ml/jour'
            },
          ]
        }
      ]
    },
    '10-12': {
      'title': '10-12 mois',
      'emoji': '👶',
      'color': Color(0xFFFFCDD2),
      'mainColor': Color(0xFFE91E63),
      'description': 'Vers l\'alimentation familiale',
      'intro': 'Bébé peut manger des morceaux mous. Il commence à manger avec les doigts. 3 repas par jour + 1-2 collations.',
      'categories': [
        {
          'name': 'Toutes les viandes',
          'icon': '🥩',
          'items': [
            {
              'name': 'Bœuf haché',
              'emoji': '🥩',
              'desc': 'Viande rouge - Riche en fer',
              'qty': '20g/jour'
            },
            {
              'name': 'Agneau',
              'emoji': '🐑',
              'desc': 'Tendre et savoureux',
              'qty': '20g/jour'
            },
            {
              'name': 'Porc',
              'emoji': '🐷',
              'desc': 'Filet ou côtelette',
              'qty': '20g/jour'
            },
            {
              'name': 'Jambon blanc',
              'emoji': '🥓',
              'desc': 'Sans couenne, qualité supérieure',
              'qty': '20g/jour'
            },
          ]
        },
        {
          'name': 'Poissons variés',
          'icon': '🐟',
          'items': [
            {
              'name': 'Saumon',
              'emoji': '🐠',
              'desc': 'Riche en oméga-3',
              'qty': '20g/jour'
            },
            {
              'name': 'Thon',
              'emoji': '🐟',
              'desc': 'En conserve au naturel',
              'qty': '20g/jour'
            },
            {
              'name': 'Maquereau',
              'emoji': '🐡',
              'desc': 'Poisson gras bénéfique',
              'qty': '20g/jour'
            },
          ]
        },
        {
          'name': 'Œufs',
          'icon': '🥚',
          'items': [
            {
              'name': 'Œuf entier',
              'emoji': '🥚',
              'desc': 'Dur, brouillé ou omelette',
              'qty': '1/2 œuf'
            },
          ]
        },
        {
          'name': 'Produits laitiers',
          'icon': '🥛',
          'items': [
            {
              'name': 'Yaourt nature',
              'emoji': '🥛',
              'desc': 'Entier, sans sucre',
              'qty': '1 pot/jour'
            },
            {
              'name': 'Fromage blanc',
              'emoji': '🥛',
              'desc': 'Entier, nature',
              'qty': '60g'
            },
            {
              'name': 'Petit-suisse',
              'emoji': '🥛',
              'desc': 'Nature de préférence',
              'qty': '1-2/jour'
            },
            {
              'name': 'Emmental',
              'emoji': '🧀',
              'desc': 'Râpé sur les pâtes',
              'qty': '10-15g'
            },
            {
              'name': 'Gruyère',
              'emoji': '🧀',
              'desc': 'Petits morceaux',
              'qty': '10-15g'
            },
            {
              'name': 'Fromage à tartiner',
              'emoji': '🧀',
              'desc': 'Type Kiri, sur du pain',
              'qty': '20g'
            },
          ]
        },
        {
          'name': 'Tous les légumes',
          'icon': '🥗',
          'items': [
            {
              'name': 'Tomate',
              'emoji': '🍅',
              'desc': 'Pelée, épépinée, bien mûre',
              'qty': '30-50g'
            },
            {
              'name': 'Concombre',
              'emoji': '🥒',
              'desc': 'Pelé et épépiné',
              'qty': '20-30g'
            },
            {
              'name': 'Poivron',
              'emoji': '🫑',
              'desc': 'Bien cuit et mixé',
              'qty': '20-30g'
            },
            {
              'name': 'Avocat',
              'emoji': '🥑',
              'desc': 'Écrasé ou en morceaux',
              'qty': '30-40g'
            },
            {
              'name': 'Champignons',
              'emoji': '🍄',
              'desc': 'Bien cuits et coupés',
              'qty': '20-30g'
            },
            {
              'name': 'Salade',
              'emoji': '🥬',
              'desc': 'Feuilles tendres hachées',
              'qty': '10-20g'
            },
          ]
        },
        {
          'name': 'Fruits frais',
          'icon': '🍓',
          'items': [
            {
              'name': 'Fraise',
              'emoji': '🍓',
              'desc': 'Coupée en petits morceaux',
              'qty': '50-80g'
            },
            {
              'name': 'Framboise',
              'emoji': '🫐',
              'desc': 'Écrasée au début',
              'qty': '30-50g'
            },
            {
              'name': 'Myrtille',
              'emoji': '🫐',
              'desc': 'Coupée en deux',
              'qty': '30-50g'
            },
            {
              'name': 'Orange',
              'emoji': '🍊',
              'desc': 'Quartiers sans peau',
              'qty': '1/2 orange'
            },
            {
              'name': 'Clémentine',
              'emoji': '🍊',
              'desc': 'Sans pépins',
              'qty': '1 entière'
            },
            {
              'name': 'Raisin',
              'emoji': '🍇',
              'desc': 'Coupé en 4 (risque d\'étouffement)',
              'qty': '30-50g'
            },
            {
              'name': 'Pastèque',
              'emoji': '🍉',
              'desc': 'Sans pépins, morceaux',
              'qty': '50-80g'
            },
            {
              'name': 'Ananas',
              'emoji': '🍍',
              'desc': 'Frais, petits morceaux',
              'qty': '30-50g'
            },
          ]
        },
        {
          'name': 'Légumineuses',
          'icon': '🫘',
          'items': [
            {
              'name': 'Lentilles corail',
              'emoji': '🫘',
              'desc': 'Très digestes, bien cuites',
              'qty': '20-30g'
            },
            {
              'name': 'Pois chiches',
              'emoji': '🫘',
              'desc': 'Écrasés en houmous',
              'qty': '20-30g'
            },
            {
              'name': 'Haricots rouges',
              'emoji': '🫘',
              'desc': 'Mixés ou écrasés',
              'qty': '20-30g'
            },
          ]
        },
        {
          'name': 'Féculents complets',
          'icon': '🍝',
          'items': [
            {
              'name': 'Pâtes alphabet',
              'emoji': '🔤',
              'desc': 'Ludiques pour manger seul',
              'qty': '30-50g'
            },
            {
              'name': 'Riz complet',
              'emoji': '🍚',
              'desc': 'Plus nutritif',
              'qty': '30-50g'
            },
            {
              'name': 'Couscous',
              'emoji': '🥣',
              'desc': 'Facile à manger',
              'qty': '30-50g'
            },
            {
              'name': 'Pain complet',
              'emoji': '🍞',
              'desc': 'Tranches ou bâtonnets',
              'qty': '20-30g'
            },
            {
              'name': 'Biscottes',
              'emoji': '🍞',
              'desc': 'Nature, pour le goûter',
              'qty': '1-2 biscottes'
            },
          ]
        },
        {
          'name': 'Herbes et épices douces',
          'icon': '🌿',
          'items': [
            {
              'name': 'Persil',
              'emoji': '🌿',
              'desc': 'Frais, haché finement',
              'qty': 'Une pincée'
            },
            {
              'name': 'Basilic',
              'emoji': '🌿',
              'desc': 'Doux et aromatique',
              'qty': 'Une pincée'
            },
            {
              'name': 'Cannelle',
              'emoji': '🥄',
              'desc': 'Dans les compotes',
              'qty': 'Une pincée'
            },
            {
              'name': 'Vanille',
              'emoji': '🥄',
              'desc': 'Naturelle dans les laitages',
              'qty': 'Une pincée'
            },
          ]
        },
        {
          'name': 'Lait',
          'icon': '🍼',
          'items': [
            {
              'name': 'Lait de croissance',
              'emoji': '🍼',
              'desc': 'De 10-12 mois à 3 ans',
              'qty': '500ml/jour min'
            },
          ]
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final baby = context
        .watch<BabyProvider>()
        .selectedBaby;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Header moderne
          SliverAppBar(
            expandedHeight: baby != null ? 180 : 140,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                  '🍽️', style: TextStyle(fontSize: 32)),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Guide Alimentaire',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Diversification mois par mois',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (baby != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                      '👶', style: TextStyle(fontSize: 24)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        baby.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${baby.ageInMonths} mois',
                                        style: const TextStyle(fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Menu de sélection des âges
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: foodGuide.length,
                itemBuilder: (context, index) {
                  final key = foodGuide.keys.elementAt(index);
                  final range = foodGuide[key];
                  final isSelected = selectedMonth == index;
                  final isRelevant = baby != null &&
                      _isRelevantForBaby(key, baby.ageInMonths);

                  return GestureDetector(
                    onTap: () => setState(() => selectedMonth = index),
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                          colors: [range['mainColor'], range['color']],
                        )
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? range['mainColor']
                              : range['color'].withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? range['mainColor'].withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: isSelected ? 12 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            range['emoji'],
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            range['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : range['mainColor'],
                            ),
                          ),
                          if (isRelevant) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '⭐',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Contenu détaillé
          SliverToBoxAdapter(
            child: _buildDetailedContent(
                foodGuide.values.elementAt(selectedMonth)),
          ),
        ],
      ),
    );
  }

  bool _isRelevantForBaby(String key, int babyAge) {
    final parts = key.split('-');
    final minAge = int.parse(parts[0]);
    final maxAge = int.parse(parts[1]);
    return babyAge >= minAge && babyAge <= maxAge;
  }

  Widget _buildDetailedContent(Map<String, dynamic> range) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: range['color'].withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: range['mainColor'], width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(range['emoji'], style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            range['title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: range['mainColor'],
                            ),
                          ),
                          Text(
                            range['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: range['mainColor'].withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    range['intro'],
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Catégories d'aliments
          ...List.generate(range['categories'].length, (catIndex) {
            final category = range['categories'][catIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de catégorie
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: range['color'],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          category['icon'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: range['mainColor'],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: range['color'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${category['items'].length}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: range['mainColor'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste des aliments
                ...List.generate(category['items'].length, (itemIndex) {
                  final item = category['items'][itemIndex];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: range['color'].withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Emoji
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: range['color'].withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              item['emoji'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: range['mainColor'].withOpacity(
                                          0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item['qty'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: range['mainColor'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['desc'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondaryColor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),
              ],
            );
          }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}