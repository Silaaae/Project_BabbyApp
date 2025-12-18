import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../utils/helpers.dart';

class BabyProfileScreen extends StatelessWidget {
  const BabyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final babyProvider = Provider.of<BabyProvider>(context);
    final baby = babyProvider.selectedBaby;

    if (baby == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Aucun bébé sélectionné')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil de bébé'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: baby.gender == 'male'
                  ? Colors.blue.shade100
                  : Colors.pink.shade100,
              child: Icon(
                baby.gender == 'male' ? Icons.boy : Icons.girl,
                size: 60,
                color: baby.gender == 'male' ? Colors.blue : Colors.pink,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              baby.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Helpers.getGenderText(baby.gender),
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(context, baby),
            const SizedBox(height: 16),
            if (baby.birthWeight != null ||
                baby.birthHeight != null ||
                baby.birthHeadCircumference != null)
              _buildBirthMeasuresCard(context, baby),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, baby) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              'Date de naissance',
              Helpers.formatDate(baby.birthDate),
              Icons.cake,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Âge',
              Helpers.getAgeText(baby.ageInMonths),
              Icons.calendar_today,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Nombre de jours',
              '${baby.ageInDays} jours',
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthMeasuresCard(BuildContext context, baby) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mesures à la naissance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (baby.birthWeight != null)
              _buildInfoRow(
                'Poids',
                '${baby.birthWeight} kg',
                Icons.monitor_weight,
              ),
            if (baby.birthWeight != null && baby.birthHeight != null)
              const Divider(height: 24),
            if (baby.birthHeight != null)
              _buildInfoRow(
                'Taille',
                '${baby.birthHeight} cm',
                Icons.height,
              ),
            if (baby.birthHeight != null && baby.birthHeadCircumference != null)
              const Divider(height: 24),
            if (baby.birthHeadCircumference != null)
              _buildInfoRow(
                'Périmètre crânien',
                '${baby.birthHeadCircumference} cm',
                Icons.face,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}