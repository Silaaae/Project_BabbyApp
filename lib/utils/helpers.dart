import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String getAgeText(int ageInMonths) {
    if (ageInMonths < 12) {
      return '$ageInMonths mois';
    }
    final years = ageInMonths ~/ 12;
    final months = ageInMonths % 12;
    if (months == 0) {
      return '$years an${years > 1 ? 's' : ''}';
    }
    return '$years an${years > 1 ? 's' : ''} et $months mois';
  }

  static String getGenderText(String gender) {
    return gender == 'male' ? 'Garçon' : 'Fille';
  }
}