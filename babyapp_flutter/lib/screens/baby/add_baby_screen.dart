import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class AddBabyScreen extends StatefulWidget {
  const AddBabyScreen({Key? key}) : super(key: key);

  @override
  State<AddBabyScreen> createState() => _AddBabyScreenState();
}

class _AddBabyScreenState extends State<AddBabyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _birthHeightController = TextEditingController();
  final _birthHeadController = TextEditingController();

  String _selectedGender = 'male';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _birthWeightController.dispose();
    _birthHeightController.dispose();
    _birthHeadController.dispose();
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

  Future<void> _saveBaby() async {
    if (_formKey.currentState!.validate()) {
      final babyProvider = Provider.of<BabyProvider>(context, listen: false);

      final data = {
        'name': _nameController.text.trim(),
        'gender': _selectedGender,
        'birth_date': _selectedDate.toIso8601String().split('T')[0],
        'birth_weight': _birthWeightController.text.isEmpty
            ? null
            : double.parse(_birthWeightController.text),
        'birth_height': _birthHeightController.text.isEmpty
            ? null
            : double.parse(_birthHeightController.text),
        'birth_head_circumference': _birthHeadController.text.isEmpty
            ? null
            : double.parse(_birthHeadController.text),
      };

      final success = await babyProvider.addBaby(data);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bébé ajouté avec succès'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(babyProvider.error ?? 'Erreur'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un bébé'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Prénom',
                hint: 'Ex: Emma',
                controller: _nameController,
                validator: (v) => Validators.validateRequired(v, 'Prénom'),
                prefixIcon: const Icon(Icons.baby_changing_station),
              ),
              const SizedBox(height: 24),
              Text(
                'Sexe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderCard('male', 'Garçon', Icons.boy, Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderCard('female', 'Fille', Icons.girl, Colors.pink),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Date de naissance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
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
              Text(
                'Mesures à la naissance (optionnel)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Poids (kg)',
                hint: 'Ex: 3.5',
                controller: _birthWeightController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.monitor_weight),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Taille (cm)',
                hint: 'Ex: 50',
                controller: _birthHeightController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.height),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Périmètre crânien (cm)',
                hint: 'Ex: 35',
                controller: _birthHeadController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.face),
              ),
              const SizedBox(height: 32),
              Consumer<BabyProvider>(
                builder: (context, babyProvider, child) {
                  return CustomButton(
                    text: 'Enregistrer',
                    onPressed: _saveBaby,
                    isLoading: babyProvider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}