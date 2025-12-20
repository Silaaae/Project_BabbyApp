import 'package:flutter/material.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({Key? key}) : super(key: key);

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  // Liste des vaccins avec leur statut
  final List<Map<String, dynamic>> vaccinations = [
    {'name': '💉 BCG (Tuberculose)', 'age': 'À la naissance', 'done': false},
    {'name': '💉 Hépatite B (1ère dose)', 'age': 'À la naissance', 'done': false},
    {'name': '💉 DTC-Polio (1ère dose)', 'age': '2 mois', 'done': false},
    {'name': '💉 Hépatite B (2ème dose)', 'age': '2 mois', 'done': false},
    {'name': '💉 Haemophilus (1ère dose)', 'age': '2 mois', 'done': false},
    {'name': '💉 DTC-Polio (2ème dose)', 'age': '4 mois', 'done': false},
    {'name': '💉 Haemophilus (2ème dose)', 'age': '4 mois', 'done': false},
    {'name': '💉 DTC-Polio (3ème dose)', 'age': '6 mois', 'done': false},
    {'name': '💉 Hépatite B (3ème dose)', 'age': '6 mois', 'done': false},
    {'name': '💉 ROR (Rougeole-Oreillons-Rubéole)', 'age': '9 mois', 'done': false},
    {'name': '💉 DTC-Polio (Rappel)', 'age': '18 mois', 'done': false},
    {'name': '💉 ROR (Rappel)', 'age': '18 mois', 'done': false},
    {'name': '💉 Méningocoque', 'age': '2-4 ans', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    final completed = vaccinations.where((v) => v['done'] == true).length;
    final total = vaccinations.length;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('💉 Vaccinations'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // En-tête avec progression
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.pinkAccent],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
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
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Liste des vaccinations
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: vaccine['done']
                          ? LinearGradient(
                        colors: [
                          Colors.green[100]!,
                          Colors.white,
                        ],
                      )
                          : null,
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
                          color: vaccine['done']
                              ? Colors.green
                              : Colors.pink[100],
                          shape: BoxShape.circle,
                        ),
                        child: vaccine['done']
                            ? const Icon(Icons.check, color: Colors.white, size: 30)
                            : const Icon(Icons.vaccines, color: Colors.pink, size: 25),
                      ),
                      title: Text(
                        vaccine['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: vaccine['done']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        'Âge: ${vaccine['age']}',
                        style: TextStyle(
                          color: Colors.grey[600],
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
                        },
                      ),
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