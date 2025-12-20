class Food {
  final int id;
  final String name;
  final int minAgeMonths;
  final String category;
  final String? description;
  final String? preparationTips;
  final String? allergens;

  Food({
    required this.id,
    required this.name,
    required this.minAgeMonths,
    required this.category,
    this.description,
    this.preparationTips,
    this.allergens,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      minAgeMonths: json['min_age_months'],
      category: json['category'],
      description: json['description'],
      preparationTips: json['preparation_tips'],
      allergens: json['allergens'],
    );
  }
}