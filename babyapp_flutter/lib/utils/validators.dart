class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName est requis';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Mot de passe requis';
    if (value.length < 6) return 'Minimum 6 caractères';
    return null;
  }

  // Add this for validateEmail
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email requis';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email invalide';
    return null;
  }

  // Add this for validatePhone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Téléphone requis';
    // Simple check for numbers, adjust regex based on your country needs
    if (value.length < 8) return 'Numéro de téléphone invalide';
    return null;
  }
}