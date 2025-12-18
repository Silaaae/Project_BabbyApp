import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../services/vaccination_service.dart';
import '../../models/vaccination_model.dart';
import '../../widgets/loading_widget.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({Key? key}) : super(key: key);

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  List<Vaccination> _vaccinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVaccinations();
  }

  Future<void> _loadVaccinations() async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    if (babyProvider.selectedBaby != null) {
      try {
        final vaccinations = await VaccinationService.getBabyVaccinations(
          babyProvider.selectedBaby!.id,
        );
        setState(() {
          _vaccinations = vaccinations;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _markAsCompleted(Vaccination vaccination) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && vaccination.babyVaccinationId != null) {
      try {
        await VaccinationService.updateVaccination(
          vaccination.babyVaccinationId!,
          {
            'status': 'completed',
            'administered_at': selectedDate.toIso8601String().split('T')[0],
          },
        );
        _loadVaccinations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vaccination enregistrée'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final babyProvider = Provider.of<BabyProvider>(context);
    final baby = babyProvider.selectedBaby;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccinations'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : baby == null
          ? const Center(child: Text('Aucun bébé sélectionné'))
          : _vaccinations.isEmpty
          ? _buildEmptyState()
          : _buildVaccinationList(baby.ageInMonths),
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
              Icons.vaccines,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune vaccination',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationList(int babyAge) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _vaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = _vaccinations[index];
        final isCompleted = vaccination.status == 'completed';
        final isPending = vaccination.status == 'pending';
        final isRecommended = vaccination.recommendedAgeMonths <= babyAge;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCompleted
                  ? AppTheme.successColor
                  : isPending
                  ? AppTheme.warningColor
                  : Colors.grey.shade300,
              child: Icon(
                isCompleted ? Icons.check : Icons.vaccines,
                color: Colors.white,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    vaccination.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                if (vaccination.isMandatory)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Obligatoire',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Recommandé à ${vaccination.recommendedAgeMonths} mois',
                ),
                if (isCompleted && vaccination.administeredAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Administré le ${DateFormat('dd/MM/yyyy').format(vaccination.administeredAt!)}',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (isPending && vaccination.scheduledAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Prévu le ${DateFormat('dd/MM/yyyy').format(vaccination.scheduledAt!)}',
                    style: TextStyle(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            trailing: !isCompleted && isRecommended
                ? IconButton(
              icon: const Icon(Icons.check_circle_outline),
              color: AppTheme.successColor,
              onPressed: () => _markAsCompleted(vaccination),
            )
                : null,
            onTap: () => _showVaccinationDetails(vaccination),
          ),
        );
      },
    );
  }

  void _showVaccinationDetails(Vaccination vaccination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                vaccination.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                vaccination.description,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              if (vaccination.location != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text('Lieu: ${vaccination.location}'),
                  ],
                ),
              ],
              if (vaccination.notes != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(vaccination.notes!),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}