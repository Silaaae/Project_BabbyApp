class Baby {
  final int id;
  final int userId;
  final String name;
  final String gender;
  final DateTime birthDate;
  final double? birthWeight;
  final double? birthHeight;
  final double? birthHeadCircumference;
  final String? photo;

  Baby({
    required this.id,
    required this.userId,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.birthWeight,
    this.birthHeight,
    this.birthHeadCircumference,
    this.photo,
  });

  factory Baby.fromJson(Map<String, dynamic> json) {
    return Baby(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birth_date']),
      birthWeight: json['birth_weight'] != null
          ? double.parse(json['birth_weight'].toString())
          : null,
      birthHeight: json['birth_height'] != null
          ? double.parse(json['birth_height'].toString())
          : null,
      birthHeadCircumference: json['birth_head_circumference'] != null
          ? double.parse(json['birth_head_circumference'].toString())
          : null,
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'gender': gender,
      'birth_date': birthDate.toIso8601String().split('T')[0],
      'birth_weight': birthWeight,
      'birth_height': birthHeight,
      'birth_head_circumference': birthHeadCircumference,
      'photo': photo,
    };
  }

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  }

  int get ageInDays {
    return DateTime.now().difference(birthDate).inDays;
  }
}