import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({Key? key}) : super(key: key);

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  List<Map<String, dynamic>> vaccinations = [
    {'name': 'BCG (Tuberculose)', 'age': 'À la naissance', 'done': false},
    {'name': 'Hépatite B (1ère dose)', 'age': 'À la naissance', 'done': false},
    {'name': 'DTC-Polio (1ère dose)', 'age': '2 mois', 'done': false},
    {'name': 'Hépatite B (2ème dose)', 'age': '2 mois', 'done': false},
    {'name': 'Haemophilus (1ère dose)', 'age': '2 mois', 'done': false},
    {'name': 'DTC-Polio (2ème dose)', 'age': '4 mois', 'done': false},
    {'name': 'Haemophilus (2ème dose)', 'age': '4 mois', 'done': false},
    {'name': 'DTC-Polio (3ème dose)', 'age': '6 mois', 'done': false},
    {'name': 'Hépatite B (3ème dose)', 'age': '6 mois', 'done': false},
    {'name': 'ROR (Rougeole-Oreillons-Rubéole)', 'age': '9 mois', 'done': false},
    {'name': 'DTC-Polio (Rappel)', 'age': '18 mois', 'done': false},
    {'name': 'ROR (Rappel)', 'age': '18 mois', 'done': false},
    {'name': 'Méningocoque', 'age': '2-4 ans', 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadVaccinations();
  }

  // Obtenir le chemin du fichier
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/vaccinations.json');
  }

  // Charger les vaccinations
  Future<void> _loadVaccinations() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          vaccinations = List<Map<String, dynamic>>.from(
              json.decode(contents)
          );
        });
      }
    } catch (e) {
      // Si erreur, on garde les données par défaut
      print('Erreur de chargement: $e');
    }
  }

  // Sauvegarder les vaccinations
  Future<void> _saveVaccinations() async {
    try {
      final file = await _localFile;
      await file.writeAsString(json.encode(vaccinations));
    } catch (e) {
      print('Erreur de sauvegarde: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int completed = vaccinations.where((v) => v['done'] == true).length;
    int total = vaccinations.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('💉 Vaccinations'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progression',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$completed / $total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: total > 0 ? completed / total : 0,
                    minHeight: 10,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vaccinations.length,
              itemBuilder: (context, index) {
                final vaccine = vaccinations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: vaccine['done'] ? Colors.green : const Color(0xFFF8BBD0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        vaccine['done'] ? Icons.check : Icons.vaccines,
                        color: vaccine['done'] ? Colors.white : Colors.pink,
                        size: 25,
                      ),
                    ),
                    title: Text(
                      vaccine['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: vaccine['done'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      'Âge: ${vaccine['age']}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Checkbox(
                      value: vaccine['done'],
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          vaccine['done'] = value ?? false;
                        });
                        _saveVaccinations();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}