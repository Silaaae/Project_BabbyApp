import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/baby_provider.dart';
import '../../services/growth_service.dart';
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
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveGrowth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    final baby = babyProvider.selectedBaby;

    if (baby == null) {
      setState(() => _isLoading = false);
      return;
    }

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
        // IMPORTANT: On renvoie 'true' pour que la page précédente sache qu'il faut recharger
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text('Nouvelle Mesure', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('🎂 Date de mesure'),
              const SizedBox(height: 12),
              _buildDateTile(),
              const SizedBox(height: 28),
              _buildSectionTitle('📏 Mesures'),
              const SizedBox(height: 12),
              _buildMeasurementInput('⚖️', 'Poids (kg)', _weightController, const Color(0xFFFFE4B5)),
              const SizedBox(height: 12),
              _buildMeasurementInput('📐', 'Taille (cm)', _heightController, const Color(0xFFD4E9FF)),
              const SizedBox(height: 12),
              _buildMeasurementInput('🎀', 'Périmètre (cm)', _headController, const Color(0xFFFFD4E5)),
              const SizedBox(height: 28),
              _buildSectionTitle('📝 Notes'),
              const SizedBox(height: 12),
              _buildNotesInput(),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

  Widget _buildDateTile() => InkWell(
    onTap: () => _selectDate(context),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFE4B5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const Icon(Icons.calendar_today, color: Color(0xFFFF8C94)),
        ],
      ),
    ),
  );

  Widget _buildMeasurementInput(String icon, String label, TextEditingController ctrl, Color color) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: color.withOpacity(0.3), borderRadius: BorderRadius.circular(18)),
    child: Row(
      children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: Center(child: Text(icon, style: const TextStyle(fontSize: 24)))),
        Expanded(
          child: TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: label, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
          ),
        ),
      ],
    ),
  );

  Widget _buildNotesInput() => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade200)),
    child: TextFormField(controller: _notesController, maxLines: 3, decoration: const InputDecoration(hintText: 'Observations...', border: InputBorder.none, contentPadding: EdgeInsets.all(16))),
  );

  Widget _buildSaveButton() => SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _saveGrowth,
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB6C1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Enregistrer ✨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
}