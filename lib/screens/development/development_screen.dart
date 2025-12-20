import 'package:flutter/material.dart';

class DevelopmentScreen extends StatelessWidget {
  const DevelopmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('🎯 Développement'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard('1 mois', '👶 Premier mois',
              'Suit des objets, tourne la tête', Colors.purple),
          _buildCard('3 mois', '😊 Trois mois',
              'Sourit, gazouille, tient sa tête', Colors.pink),
          _buildCard('6 mois', '🍼 Six mois',
              'Se retourne, babille, s\'assoit', Colors.orange),
          _buildCard('9 mois', '🧸 Neuf mois',
              'Rampe, dit papa/mama, explore', Colors.blue),
          _buildCard('12 mois', '🎂 Un an',
              'Marche, dit 2-3 mots, montre du doigt', Colors.green),
          _buildCard('18 mois', '🚶 Dix-huit mois',
              'Court, mange seul, vocabulaire 10-20 mots', Colors.teal),
          _buildCard('24 mois', '🎨 Deux ans',
              'Saute, fait des puzzles, phrases simples', Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildCard(String age, String title, String desc, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    age.split(' ')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}