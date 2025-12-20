class Development {
  final int id;
  final int month;
  final String title;
  final String motorSkills;
  final String cognitiveSkills;
  final String socialSkills;
  final String languageSkills;
  final String? tips;

  Development({
    required this.id,
    required this.month,
    required this.title,
    required this.motorSkills,
    required this.cognitiveSkills,
    required this.socialSkills,
    required this.languageSkills,
    this.tips,
  });

  factory Development.fromJson(Map<String, dynamic> json) {
    return Development(
      id: json['id'],
      month: json['month'],
      title: json['title'],
      motorSkills: json['motor_skills'],
      cognitiveSkills: json['cognitive_skills'],
      socialSkills: json['social_skills'],
      languageSkills: json['language_skills'],
      tips: json['tips'],
    );
  }
}