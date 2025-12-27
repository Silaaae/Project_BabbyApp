class Food {
  final int id;
  final String name;
  final int minAgeMonths;
  final String category;
  final String? description;       // Description générale de l’aliment
  final String? preparationTips;   // Conseils de préparation pour bébé
  final String? allergens;         // Allergènes éventuels
  final String emoji;              // Emoji représentant l’aliment
  final String? quantity;          // Quantité recommandée
  final String? note;              // Note ou conseils spécifiques

  Food({
    required this.id,
    required this.name,
    required this.minAgeMonths,
    required this.category,
    required this.emoji,
    this.description,
    this.preparationTips,
    this.allergens,
    this.quantity,
    this.note,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      minAgeMonths: json['min_age_months'],
      category: json['category'],
      emoji: json['emoji'] ?? '🍽️', // Emoji par défaut si null
      description: json['description'],
      preparationTips: json['preparation_tips'],
      allergens: json['allergens'],
      quantity: json['quantity'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'min_age_months': minAgeMonths,
      'category': category,
      'emoji': emoji,
      'description': description,
      'preparation_tips': preparationTips,
      'allergens': allergens,
      'quantity': quantity,
      'note': note,
    };
  }
}
