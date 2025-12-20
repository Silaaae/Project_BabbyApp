import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/baby_provider.dart';
import '../../config/theme.dart';
import '../../utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BabyProvider>().loadBabies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final babyProvider = context.watch<BabyProvider>();
    final selectedBaby = babyProvider.selectedBaby;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header mignon
              _buildHeader(authProvider, babyProvider),

              // Baby Selector
              if (babyProvider.babies.isNotEmpty)
                _buildBabySelector(babyProvider),

              // Menu principal
              Expanded(
                child: selectedBaby != null
                    ? _buildMenuGrid(context, selectedBaby)
                    : _buildNoBabyView(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-baby'),
        backgroundColor: AppTheme.secondaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter Bébé'),
      ),
    );
  }

  Widget _buildHeader(AuthProvider authProvider, BabyProvider babyProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar mignon
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Text(
                authProvider.user?.name[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '👋 Bonjour,',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  authProvider.user?.name ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBabySelector(BabyProvider babyProvider) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: babyProvider.babies.length,
        itemBuilder: (context, index) {
          final baby = babyProvider.babies[index];
          final isSelected = baby.id == babyProvider.selectedBaby?.id;

          return GestureDetector(
            onTap: () => babyProvider.selectBaby(baby),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppTheme.primaryColor.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : (baby.gender == 'male'
                          ? Colors.blue.shade50
                          : Colors.pink.shade50),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      baby.gender == 'male' ? '👶' : '👧',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    baby.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${baby.ageInMonths} mois',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, baby) {
    final menuItems = [
      {
        'title': 'Croissance',
        'icon': '📊',
        'color': const Color(0xFF6C63FF),
        'route': '/growth',
      },
      {
        'title': 'Développement',
        'icon': '🎯',
        'color': const Color(0xFFFF6B9D),
        'route': '/development',
      },
      {
        'title': 'Alimentation',
        'icon': '🍎',
        'color': const Color(0xFF4CAF50),
        'route': '/food',
      },
      {
        'title': 'Vaccinations',
        'icon': '💉',
        'color': const Color(0xFFFF9800),
        'route': '/vaccination',
      },
      {
        'title': 'Rendez-vous',
        'icon': '📅',
        'color': const Color(0xFF2196F3),
        'route': '/appointment',
      },
      {
        'title': 'Profil',
        'icon': '👤',
        'color': const Color(0xFF9C27B0),
        'route': '/baby-profile',
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(
          context,
          title: item['title'] as String,
          icon: item['icon'] as String,
          color: item['color'] as Color,
          route: item['route'] as String,
        );
      },
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required String title,
        required String icon,
        required Color color,
        required String route,
      }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                icon,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoBabyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '👶',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucun bébé ajouté',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ajoutez votre premier bébé\npour commencer!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}