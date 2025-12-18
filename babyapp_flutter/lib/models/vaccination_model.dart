class Vaccination {
  final int id;
  final String name;
  final int recommendedAgeMonths;
  final String description;
  final bool isMandatory;
  final int? babyVaccinationId;
  final DateTime? administeredAt;
  final DateTime? scheduledAt;
  final String? status;
  final String? location;
  final String? notes;

  Vaccination({
    required this.id,
    required this.name,
    required this.recommendedAgeMonths,
    required this.description,
    required this.isMandatory,
    this.babyVaccinationId,
    this.administeredAt,
    this.scheduledAt,
    this.status,
    this.location,
    this.notes,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'],
      name: json['name'],
      recommendedAgeMonths: json['recommended_age_months'],
      description: json['description'],
      isMandatory: json['is_mandatory'] == 1 || json['is_mandatory'] == true,
      babyVaccinationId: json['baby_vaccination_id'],
      administeredAt: json['administered_at'] != null
          ? DateTime.parse(json['administered_at'])
          : null,
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'])
          : null,
      status: json['status'],
      location: json['location'],
      notes: json['notes'],
    );
  }
}