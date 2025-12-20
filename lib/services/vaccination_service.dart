import 'api_service.dart';
import '../models/vaccination_model.dart';

class VaccinationService {
  static Future<List<Vaccination>> getVaccinations() async {
    final response = await ApiService.get('vaccinations');
    final List<dynamic> data = response is List ? response as List : [];    return data.map((json) => Vaccination.fromJson(json)).toList();
  }

  static Future<List<Vaccination>> getBabyVaccinations(int babyId) async {
    final response = await ApiService.get('babies/$babyId/vaccinations');
    final List<dynamic> data = response is List ? response as List : [];    return data.map((json) => Vaccination.fromJson(json)).toList();
  }

  static Future<void> addBabyVaccination(
      int babyId,
      Map<String, dynamic> data,
      ) async {
    await ApiService.post('babies/$babyId/vaccinations', data);
  }

  static Future<void> updateVaccination(
      int id,
      Map<String, dynamic> data,
      ) async {
    await ApiService.put('baby-vaccinations/$id', data);
  }
}