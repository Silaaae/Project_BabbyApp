import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../services/growth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class AddGrowthScreen extends StatefulWidget {
  const AddGrowthScreen({Key? key}) : super(key: key);

  @override
  State<AddGrowthScreen> createState() => _AddGrowthScreenState();
}

class _AddGrowthScreenState extends State<AddGrowthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveGrowth() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final babyProvider = Provider.of<BabyProvider>(context, listen: false);
      final baby = babyProvider.selectedBaby!;

      final ageInMonths = (DateTime.now().year - baby.birthDate.year) * 12 +
          DateTime.now().month - baby.birthDate.month;

      final data = {
        'measured_at': _selectedDate.toIso8601String().split('T')[0],
        'weight': double.parse(_weightController.text),
        'height': double.parse(_heightController.text),
        'head_circumference': _headController.text.isEmpty
            ? null
            : double.parse(_headController.text),
        'age_in_months': ageInMonths,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
      };

      try {
        await GrowthService.addGrowth(baby.id, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mesure ajoutée avec succès'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une mesure'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date de mesure',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Poids (kg) *',
                hint: 'Ex: 5.5',
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: (v) => Validators.validateRequired(v, 'Poids'),
                prefixIcon: const Icon(Icons.monitor_weight),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Taille (cm) *',
                hint: 'Ex: 60',
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: (v) => Validators.validateRequired(v, 'Taille'),
                prefixIcon: const Icon(Icons.height),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Périmètre crânien (cm)',
                hint: 'Ex: 40',
                controller: _headController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.face),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Observations...',
                  prefixIcon: const Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Enregistrer',
                onPressed: _saveGrowth,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}