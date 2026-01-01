import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final Map<String, Map<String, dynamic>> appointments = {
    'pediatre': {
      'emoji': '👨‍⚕️',
      'label': 'Pédiatre',
      'color': Color(0xFFD4E9FF),
      'selected': false,
      'date': null,
    },
    'vaccination': {
      'emoji': '💉',
      'label': 'Vaccination',
      'color': Color(0xFFFFD4E5),
      'selected': false,
      'date': null,
    },
    'dentiste': {
      'emoji': '🦷',
      'label': 'Dentiste',
      'color': Color(0xFFE8F5E9),
      'selected': false,
      'date': null,
    },
    'croissance': {
      'emoji': '📏',
      'label': 'Mesure',
      'color': Color(0xFFFFE4B5),
      'selected': false,
      'date': null,
    },
  };

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
            const Text('📅', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              'Mes Rendez-vous',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✨ Sélectionne tes prochains rendez-vous',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            ...appointments.entries.map((entry) {
              return _buildAppointmentCard(entry.key, entry.value);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String key, Map<String, dynamic> data) {
    final isSelected = data['selected'] as bool;
    final date = data['date'] as DateTime?;

    return GestureDetector(
      onTap: () async {
        if (isSelected) {
          // Désélectionner
          setState(() {
            appointments[key]!['selected'] = false;
            appointments[key]!['date'] = null;
          });
        } else {
          // Sélectionner et choisir une date
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
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

          if (selectedDate != null) {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFFFFB6C1),
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (selectedTime != null) {
              final fullDate = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              setState(() {
                appointments[key]!['selected'] = true;
                appointments[key]!['date'] = fullDate;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${data['label']} ajouté ! 🎉'),
                  backgroundColor: const Color(0xFF81C784),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              data['color'] as Color,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB6C1) : const Color(0xFFFFE4B5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFFB6C1).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: (data['color'] as Color).withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  data['emoji'],
                  style: TextStyle(fontSize: isSelected ? 42 : 36),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['label'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isSelected && date != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Color(0xFFFF8C94),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('dd/MM/yyyy').format(date),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Color(0xFFFF8C94),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('HH:mm').format(date),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildDaysUntil(date),
                      ],
                    )
                  else
                    Text(
                      'Appuie pour planifier',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB6C1), Color(0xFFFF8C94)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysUntil(DateTime date) {
    final now = DateTime.now();
    final daysUntil = date.difference(now).inDays;

    if (daysUntil < 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Passé',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    } else if (daysUntil == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Aujourd'hui ! 🎯",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    } else if (daysUntil == 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB347), Color(0xFFFFCC33)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Demain 🌟',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    } else if (daysUntil <= 7) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF81C784), Color(0xFF66BB6A)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Dans $daysUntil jours',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E9FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Dans $daysUntil jours',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade700,
          ),
        ),
      );
    }
  }
}