class Growth {
  final int id;
  final int babyId;
  final DateTime measuredAt;
  final double weight;
  final double height;
  final double? headCircumference;
  final int ageInMonths;
  final String? notes;

  Growth({
    required this.id,
    required this.babyId,
    required this.measuredAt,
    required this.weight,
    required this.height,
    this.headCircumference,
    required this.ageInMonths,
    this.notes,
  });

  factory Growth.fromJson(Map<String, dynamic> json) {
    return Growth(
      id: json['id'],
      babyId: json['baby_id'],
      measuredAt: DateTime.parse(json['measured_at']),
      weight: double.parse(json['weight'].toString()),
      height: double.parse(json['height'].toString()),
      headCircumference: json['head_circumference'] != null
          ? double.parse(json['head_circumference'].toString())
          : null,
      ageInMonths: json['age_in_months'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baby_id': babyId,
      'measured_at': measuredAt.toIso8601String().split('T')[0],
      'weight': weight,
      'height': height,
      'head_circumference': headCircumference,
      'age_in_months': ageInMonths,
      'notes': notes,
    };
  }
}