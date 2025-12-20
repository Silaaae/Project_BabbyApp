class Appointment {
  final int id;
  final int babyId;
  final String title;
  final String? description;
  final DateTime appointmentDate;
  final String? location;
  final String? doctorName;
  final String type;
  final bool reminderSent;

  Appointment({
    required this.id,
    required this.babyId,
    required this.title,
    this.description,
    required this.appointmentDate,
    this.location,
    this.doctorName,
    required this.type,
    required this.reminderSent,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      babyId: json['baby_id'],
      title: json['title'],
      description: json['description'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      location: json['location'],
      doctorName: json['doctor_name'],
      type: json['type'],
      reminderSent: json['reminder_sent'] == 1 || json['reminder_sent'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baby_id': babyId,
      'title': title,
      'description': description,
      'appointment_date': appointmentDate.toIso8601String(),
      'location': location,
      'doctor_name': doctorName,
      'type': type,
    };
  }
}