import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/baby_provider.dart';
import '../../services/appointment_service.dart';
import '../../models/appointment_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    if (babyProvider.selectedBaby != null) {
      try {
        final appointments = await AppointmentService.getAppointments(
          babyProvider.selectedBaby!.id,
        );
        setState(() {
          _appointments = appointments;
          _isLoading = false;
        });
      } catch (e) {
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
        title: const Text('Rendez-vous'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _appointments.isEmpty
          ? _buildEmptyState()
          : _buildAppointmentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAppointmentDialog,
        child: const Icon(Icons.add),
      ),
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
              Icons.event_note,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun rendez-vous',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre premier rendez-vous',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList() {
    final now = DateTime.now();
    final upcoming = _appointments
        .where((a) => a.appointmentDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
    final past = _appointments
        .where((a) => a.appointmentDate.isBefore(now))
        .toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (upcoming.isNotEmpty) ...[
          Text(
            'À venir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ...upcoming.map((appointment) => _buildAppointmentCard(
            appointment,
            isUpcoming: true,
          )),
          const SizedBox(height: 24),
        ],
        if (past.isNotEmpty) ...[
          Text(
            'Passés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ...past.map((appointment) => _buildAppointmentCard(
            appointment,
            isUpcoming: false,
          )),
        ],
      ],
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, {required bool isUpcoming}) {
    return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isUpcoming
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.grey.shade200,
              child: Icon(
                _getTypeIcon(appointment.type),
                color: isUpcoming ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
            title: Text(
              appointment.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUpcoming ? null : Colors.grey,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(appointment.appointmentDate),
                ),
                if (appointment.doctorName != null) ...[
                  const SizedBox(height: 4),
                  Text('Dr. ${appointment.doctorName}'),
                ],
                if (appointment.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(appointment.location!)),
                    ],
                  ),
                ],
              ],),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppTheme.errorColor,
            onPressed: () => _deleteAppointment(appointment.id),
          ),
        ),
    );
  }
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'checkup':
        return Icons.medical_services;
      case 'vaccination':
        return Icons.vaccines;
      case 'specialist':
        return Icons.local_hospital;
      default:
        return Icons.event;
    }
  }
  Future<void> _deleteAppointment(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous supprimer ce rendez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await AppointmentService.deleteAppointment(id);
        _loadAppointments();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous supprimé'),
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
  void _showAddAppointmentDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final doctorController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    String selectedType = 'checkup';
    bool isLoading = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nouveau rendez-vous',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Titre',
                  hint: 'Ex: Visite pédiatre',
                  controller: titleController,
                  validator: (v) => Validators.validateRequired(v, 'Titre'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'checkup', child: Text('Contrôle')),
                    DropdownMenuItem(value: 'vaccination', child: Text('Vaccination')),
                    DropdownMenuItem(value: 'specialist', child: Text('Spécialiste')),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setModalState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(selectedDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setModalState(() {
                              selectedTime = time;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Heure',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(selectedTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Médecin',
                  hint: 'Nom du médecin',
                  controller: doctorController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Lieu',
                  hint: 'Cabinet médical',
                  controller: locationController,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Notes...',
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Enregistrer',
                  isLoading: isLoading,
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Le titre est requis'),
                          backgroundColor: AppTheme.errorColor,
                        ),
                      );
                      return;
                    }

                    setModalState(() {
                      isLoading = true;
                    });

                    final babyProvider = Provider.of<BabyProvider>(
                      context,
                      listen: false,
                    );

                    final appointmentDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    try {
                      await AppointmentService.createAppointment(
                        babyProvider.selectedBaby!.id,
                        {
                          'title': titleController.text,
                          'description': descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text,
                          'appointment_date': appointmentDateTime.toIso8601String(),
                          'type': selectedType,
                          'doctor_name': doctorController.text.isEmpty
                              ? null
                              : doctorController.text,
                          'location': locationController.text.isEmpty
                              ? null
                              : locationController.text,
                        },
                      );

                      if (mounted) {
                        Navigator.pop(context);
                        _loadAppointments();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rendez-vous ajouté'),
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
                    } finally {
                      setModalState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}