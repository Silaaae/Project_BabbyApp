import 'package:flutter/material.dart';
import '../models/baby_model.dart';
import '../config/theme.dart';

class BabyCard extends StatelessWidget {
  final Baby baby;
  final VoidCallback onTap;

  const BabyCard({
    Key? key,
    required this.baby,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: baby.gender == 'male'
              ? Colors.blue.shade100
              : Colors.pink.shade100,
          child: Icon(
            baby.gender == 'male' ? Icons.boy : Icons.girl,
            color: baby.gender == 'male' ? Colors.blue : Colors.pink,
          ),
        ),
        title: Text(
          baby.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${baby.ageInMonths} mois'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}