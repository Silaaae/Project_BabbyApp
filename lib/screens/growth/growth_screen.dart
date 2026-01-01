import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({Key? key}) : super(key: key);

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final List<Map<String, dynamic>> measurements = [];

  void _addMeasurement() {
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    final headController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF8F0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD4E5).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('📏', style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Nouvelle Mesure',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📅 Date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: const Color(0xFFFFB6C1),
                                    onPrimary: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) setModalState(() => selectedDate = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFE4B5), width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4B5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFFF8C94),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '📊 Mesures',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMeasurementField(
                        icon: '⚖️',
                        label: 'Poids (kg)',
                        hint: 'Ex: 5.5',
                        controller: weightController,
                        color: const Color(0xFFFFE4B5),
                      ),
                      const SizedBox(height: 12),
                      _buildMeasurementField(
                        icon: '📐',
                        label: 'Taille (cm)',
                        hint: 'Ex: 60',
                        controller: heightController,
                        color: const Color(0xFFD4E9FF),
                      ),
                      const SizedBox(height: 12),
                      _buildMeasurementField(
                        icon: '🎀',
                        label: 'Périmètre crânien (cm)',
                        hint: 'Ex: 40 (optionnel)',
                        controller: headController,
                        color: const Color(0xFFFFD4E5),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFB6C1), Color(0xFFFF8C94)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB6C1).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (weightController.text.isNotEmpty &&
                                  heightController.text.isNotEmpty) {
                                setState(() {
                                  measurements.add({
                                    'date': selectedDate,
                                    'weight': double.tryParse(weightController.text) ?? 0,
                                    'height': double.tryParse(heightController.text) ?? 0,
                                    'head': headController.text.isNotEmpty
                                        ? double.tryParse(headController.text)
                                        : null,
                                  });
                                  measurements.sort((a, b) =>
                                      (b['date'] as DateTime).compareTo(a['date'] as DateTime));
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Mesure ajoutée ! 🎉'),
                                    backgroundColor: const Color(0xFF81C784),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Poids et taille requis !'),
                                    backgroundColor: const Color(0xFFEF5350),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Enregistrer',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('✨', style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementField({
    required String icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📊', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              'Croissance',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: measurements.isEmpty ? _buildEmpty() : _buildList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMeasurement,
        backgroundColor: const Color(0xFFFFB6C1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ajouter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 8,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFB6C1).withOpacity(0.3),
                  const Color(0xFFFF8C94).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('📊', style: TextStyle(fontSize: 60)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune mesure',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commence à suivre la croissance !',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addMeasurement,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Ajouter une mesure',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB6C1),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: measurements.length,
      itemBuilder: (context, index) {
        final m = measurements[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFE4B5), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFB6C1).withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4B5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFFF8C94),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd/MM/yyyy').format(m['date']),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
                      onPressed: () {
                        setState(() {
                          measurements.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Mesure supprimée'),
                            backgroundColor: const Color(0xFFEF5350),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMeasureCard(
                        '⚖️',
                        'Poids',
                        '${m['weight']} kg',
                        const Color(0xFFFFE4B5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMeasureCard(
                        '📏',
                        'Taille',
                        '${m['height']} cm',
                        const Color(0xFFD4E9FF),
                      ),
                    ),
                  ],
                ),
                if (m['head'] != null) ...[
                  const SizedBox(height: 12),
                  _buildMeasureCard(
                    '🎀',
                    'Périmètre crânien',
                    '${m['head']} cm',
                    const Color(0xFFFFD4E5),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeasureCard(String emoji, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}