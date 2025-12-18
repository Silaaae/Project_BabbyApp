import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/baby_provider.dart';
import '../../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    await babyProvider.loadBabies();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final babyProvider = Provider.of<BabyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BabyApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: babyProvider.isLoading
          ? const LoadingWidget()
          : babyProvider.babies.isEmpty
          ? _buildNoBabyState()
          : _buildHomeContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addBaby).then((_) {
            _loadData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoBabyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.baby_changing_station,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            const Text(
              'Aucun bébé',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre premier bébé pour commencer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final babyProvider = Provider.of<BabyProvider>(context);
    final baby = babyProvider.selectedBaby;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (baby != null) _buildBabyCard(baby),
          const SizedBox(height: 24),
          const Text(
            'Fonctionnalités',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureGrid(),
        ],
      ),
    );
  }

  Widget _buildBabyCard(baby) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.babyProfile);
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: baby.gender == 'male'
              ? Colors.blue.shade100
              : Colors.pink.shade100,
          child: Icon(
            baby.gender == 'male' ? Icons.boy : Icons.girl,
            size: 30,
            color: baby.gender == 'male' ? Colors.blue : Colors.pink,
          ),
        ),
        title: Text(
          baby.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('${baby.ageInMonths} mois (${baby.ageInDays} jours)'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'title': 'Croissance',
        'icon': Icons.show_chart,
        'color': Colors.blue,
        'route': AppRoutes.growth,
      },
      {
        'title': 'Développement',
        'icon': Icons.child_care,
        'color': Colors.purple,
        'route': AppRoutes.development,
      },
      {
        'title': 'Alimentation',
        'icon': Icons.restaurant,
        'color': Colors.orange,
        'route': AppRoutes.food,
      },
      {
        'title': 'Vaccinations',
        'icon': Icons.vaccines,
        'color': Colors.green,
        'route': AppRoutes.vaccination,
      },
      {
        'title': 'Rendez-vous',
        'icon': Icons.event,
        'color': Colors.red,
        'route': AppRoutes.appointment,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, feature['route'] as String);
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature['icon'] as IconData,
                  size: 48,
                  color: feature['color'] as Color,
                ),
                const SizedBox(height: 12),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}