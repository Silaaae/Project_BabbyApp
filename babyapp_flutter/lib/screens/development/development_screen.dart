import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../services/api_service.dart';
import '../../models/development_model.dart';
import '../../widgets/loading_widget.dart';

class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({Key? key}) : super(key: key);

  @override
  State<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends State<DevelopmentScreen> {
  List<Development> _developments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevelopments();
  }

  Future<void> _loadDevelopments() async {
    try {
      final response = await ApiService.get('developments');
      final List<dynamic> data = response is List ? response as List : [];      setState(() {
        _developments = data.map((json) => Development.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final babyProvider = Provider.of<BabyProvider>(context);
    final baby = babyProvider.selectedBaby;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Développement'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : baby == null
          ? const Center(child: Text('Aucun bébé sélectionné'))
          : _buildDevelopmentList(baby.ageInMonths),
    );
  }

  Widget _buildDevelopmentList(int babyAge) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _developments.length,
      itemBuilder: (context, index) {
        final dev = _developments[index];
        final isCurrentMonth = dev.month == babyAge;
        final isPastMonth = dev.month < babyAge;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: isCurrentMonth
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: isCurrentMonth
                  ? AppTheme.primaryColor
                  : isPastMonth
                  ? AppTheme.successColor
                  : Colors.grey.shade300,
              child: Icon(
                isCurrentMonth
                    ? Icons.stars
                    : isPastMonth
                    ? Icons.check
                    : Icons.lock_clock,
                color: Colors.white,
              ),
            ),
            title: Text(
              dev.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentMonth ? AppTheme.primaryColor : null,
              ),
            ),
            subtitle: Text('${dev.month} mois'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkillSection(
                      'Motricité',
                      dev.motorSkills,
                      Icons.directions_run,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildSkillSection(
                      'Cognitif',
                      dev.cognitiveSkills,
                      Icons.psychology,
                      Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    _buildSkillSection(
                      'Social',
                      dev.socialSkills,
                      Icons.people,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildSkillSection(
                      'Langage',
                      dev.languageSkills,
                      Icons.chat,
                      Colors.orange,
                    ),
                    if (dev.tips != null && dev.tips!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppTheme.warningColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Conseils',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.warningColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(dev.tips!),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillSection(
      String title,
      String content,
      IconData icon,
      Color color,
      ) {
    return Row(
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
    );
  }
}