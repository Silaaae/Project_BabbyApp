import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/baby_provider.dart';
import '../../services/growth_service.dart';
import '../../models/growth_model.dart';
import '../../widgets/loading_widget.dart';
import '../../utils/helpers.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({Key? key}) : super(key: key);

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  List<Growth> _growths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrowths();
  }

  Future<void> _loadGrowths() async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    if (babyProvider.selectedBaby != null) {
      try {
        final growths = await GrowthService.getGrowths(
          babyProvider.selectedBaby!.id,
        );
        setState(() {
          _growths = growths;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final babyProvider = Provider.of<BabyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de croissance'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _growths.isEmpty
          ? _buildEmptyState()
          : _buildGrowthList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addGrowth);
          _loadGrowths();
        },
        child: const Icon(Icons.add),
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
              Icons.show_chart,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune mesure',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez la première mesure de croissance',
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

  Widget _buildGrowthList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _growths.length,
      itemBuilder: (context, index) {
        final growth = _growths[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Helpers.formatDate(growth.measuredAt),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${growth.ageInMonths} mois',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMeasureItem(
                        'Poids',
                        '${growth.weight} kg',
                        Icons.monitor_weight,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMeasureItem(
                        'Taille',
                        '${growth.height} cm',
                        Icons.height,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                if (growth.headCircumference != null) ...[
                  const SizedBox(height: 12),
                  _buildMeasureItem(
                    'Périmètre crânien',
                    '${growth.headCircumference} cm',
                    Icons.face,
                    Colors.orange,
                  ),
                ],
                if (growth.notes != null && growth.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Note: ${growth.notes}',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeasureItem(
      String label,
      String value,
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
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
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